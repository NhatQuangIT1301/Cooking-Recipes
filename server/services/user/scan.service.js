const { GoogleGenerativeAI } = require("@google/generative-ai");
const fs = require("fs").promises; 
// const fsStandard = require("fs");  
const axios = require('axios');
const FormData = require('form-data');
require("dotenv").config();
// Models
const Recipe = require("../../models/Recipe");
const PantryItem = require("../../models/PantryItem");
const ProductCache = require("../../models/ProductCache"); 
const RecipeHistory = require("../../models/RecipeHistory");
const MasterIngredient = require("../../models/MasterIngredients");

// Utils
const { 
    getBarcodePrompt, 
    getImageScanPrompt, 
    getRecipeSuggestionPrompt 
} = require("../../utils/scanPrompts");

// Config AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ 
  model: "gemini-2.5-flash", 
  generationConfig: { 
      responseMimeType: "application/json",
      temperature: 1.0 
  },
});

// --- HELPER FUNCTIONS ---
const cleanAndParseJSON = (text) => {
    try {
        const jsonMatch = text.match(/```(?:json)?\s*([\s\S]*?)\s*```/);
        const jsonString = jsonMatch ? jsonMatch[1] : text; 
        return JSON.parse(jsonString);
    } catch (error) {
        console.error("❌ JSON Parse Error:", text.substring(0, 100));
        return null; 
    }
};

const parseNumber = (val) => {
    if (typeof val === 'number') return val;
    if (!val) return 0;
    const match = val.toString().match(/(\d+(\.\d+)?)/); 
    return match ? parseFloat(match[0]) : 0;
};

const parseCookingTime = (timeStr) => {
    if (!timeStr) return 30;
    const str = timeStr.toString().toLowerCase();
    
    // Xử lý khoảng (15-20 phút)
    const rangeMatch = str.match(/(\d+)\s*-\s*(\d+)/);
    if (rangeMatch) return Math.round((parseInt(rangeMatch[1]) + parseInt(rangeMatch[2])) / 2);

    const match = str.match(/(\d+)/);
    return match ? parseInt(match[0]) : 30;
};

const mapStorageToVietnamese = (storageInput) => {
    if (!storageInput) return 'Ngăn mát';
    const s = storageInput.toString().toUpperCase().trim();
    if (s.includes('FREEZER') || s.includes('ĐÔNG')) return 'Ngăn đông';
    if (s.includes('PANTRY') || s.includes('BẾP') || s.includes('TỦ')) return 'Tủ bếp';
    return 'Ngăn mát'; 
};

const ScanService = {
    async processBarcodeScan(barcode) {
        const cachedProduct = await ProductCache.findOne({ barcode });
        if (cachedProduct) {
            return { ...cachedProduct.toObject(), found: true, is_food: true, source: "Cache" };
        }

        let aiData = null; 
        let knownName = ""; 

        try {
            const apiResponse = await axios.get(
                `https://world.openfoodfacts.org/api/v0/product/${barcode}.json`, 
                { timeout: 3000 }
            );
            const data = apiResponse.data;
            if (data.status === 1 && data.product) { 
                const p = data.product;
                knownName = p.product_name_vi || p.product_name || "";
                aiData = {
                    found: true, is_food: true, name: knownName,
                    image_url: p.image_url || "", unit: "cái", source: "OpenFoodFacts"
                };
            }
        } catch (e) { console.log("OpenFoodFacts API failed"); }

        if (!aiData) {
            const prompt = getBarcodePrompt(barcode, knownName); 
            const result = await model.generateContent(prompt);
            aiData = cleanAndParseJSON(result.response.text());
            if (aiData) aiData.source = "Gemini AI";
        }

        if (aiData && aiData.found !== false) {
            ProductCache.updateOne({ barcode }, { $set: aiData }, { upsert: true }).catch(() => {});
        }
        return aiData;
    },
    async processImageScan(filePath, mimeType) {
        // 1. Đọc file vào Buffer MỘT LẦN DUY NHẤT
        const fileBuffer = await fs.readFile(filePath);
    
        let detectedHints = [];
        
        // Gọi Roboflow (Nếu có config)
        if (process.env.ROBOFLOW_API_KEY && process.env.ROBOFLOW_MODEL_ID) {
            try {
                const formData = new FormData();
                // FormData từ buffer cần thêm filename và contentType
                formData.append("file", fileBuffer, { 
                    filename: 'image.jpg', 
                    contentType: mimeType 
                });
            
                const roboflowUrl = `https://detect.roboflow.com/${process.env.ROBOFLOW_MODEL_ID}?api_key=${process.env.ROBOFLOW_API_KEY}&confidence=30`;
            
                const response = await axios.post(roboflowUrl, formData, { 
                headers: { ...formData.getHeaders() },
                timeout: 5000 // Set timeout để không đợi quá lâu
                });
                detectedHints = [...new Set((response.data.predictions || []).map(p => p.class))];
            } catch (err) {
                console.warn("⚠️ Roboflow failed/skipped:", err.message);
                // Không throw lỗi, vẫn tiếp tục chạy Gemini
            }
        }

        console.log("🧠 Sending Image to Gemini...");
        try {
            const imageBase64 = fileBuffer.toString("base64");
            const prompt = getImageScanPrompt(detectedHints); 
        
            const result = await model.generateContent([
                prompt, 
                { inlineData: { data: imageBase64, mimeType: mimeType } }
            ]);
        
            const ingredients = cleanAndParseJSON(result.response.text());
            if (!ingredients) throw new Error("AI response format invalid");
            return ingredients;

        } catch (error) {
            console.error("❌ Gemini Scan Error:", error.message);
                // Throw lỗi để Controller biết mà trả về Client
            throw new Error("Không thể phân tích hình ảnh lúc này. Vui lòng thử lại.");
        }
    },

    async addToPantry(userId, itemData) {
        let { name, quantity, weight, unit, image_url, calories, expiryDate, storage, note, addMethod, masterIngredientId } = itemData;
        let masterItem = null;

        // 1. Tìm MasterIngredient
        if (masterIngredientId) {
            masterItem = await MasterIngredient.findById(masterIngredientId);
        } else if (name) {
            // Tìm theo tên hoặc từ đồng nghĩa (Case insensitive)
            const regexName = new RegExp(`^${name}$`, 'i');
            masterItem = await MasterIngredient.findOne({ 
                $or: [{ name: { $regex: regexName } }, { synonyms: { $regex: regexName } }] 
            });
        }
        if (!masterItem) {
            masterItem = await MasterIngredient.findOneAndUpdate(
                { name: "Khác" },
                { 
                    $setOnInsert: { 
                        name: "Khác", 
                        category: "Khác", 
                        nutritionPer100g: { calories: 100 } 
                    } 
                },
                { upsert: true, new: true } // Tạo mới nếu chưa có, trả về doc mới nhất
            );
        }

        if ((!calories || calories === 0) && masterItem?.nutritionPer100g?.calories) {
            let totalGrams = weight > 0 ? weight : 100;
            calories = Math.round((totalGrams / 100) * masterItem.nutritionPer100g.calories);
        }
    
        if (!expiryDate && masterItem.defaultStorage) {
            const days = (storage?.toUpperCase().includes('ĐÔNG')) ? (masterItem.defaultStorage.freezer || 30) : (masterItem.defaultStorage.fridge || 3);
            const date = new Date(); date.setDate(date.getDate() + days); expiryDate = date;
        }

        const newItem = new PantryItem({
            user: userId, 
            name: name || masterItem.name, 
            masterIngredient: masterItem._id,
            quantity: Math.max(0, quantity || 1), 
            weight: Math.max(0, weight || 0),
            unit: unit || 'cái', 
            calories: Math.max(0, calories || 0),
            expiryDate: expiryDate ? new Date(expiryDate) : null,
            storage: mapStorageToVietnamese(storage), 
            addMethod: addMethod || 'MANUAL',
            image_url: image_url || "", 
            note: (note || "")
        });
        return await newItem.save();
    },

    async getPantryItems(userId) {
        const items = await PantryItem.find({ user: userId, quantity: { $gt: 0 } }).populate('masterIngredient', 'name category image nutritionPer100g synonyms').sort({ expiryDate: 1, createdAt: -1 });
        return items.map(item => {
            let daysLeft = null;
            if (item.expiryDate) {
                const now = new Date();
                const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
                const expiry = new Date(item.expiryDate.getFullYear(), item.expiryDate.getMonth(), item.expiryDate.getDate());
                daysLeft = Math.ceil((expiry - today) / (1000 * 60 * 60 * 24));
            }
            let statusLabel = (daysLeft !== null && daysLeft < 0) ? "EXPIRED" : (daysLeft <= 2) ? "WARNING" : "GOOD";
            return { ...item.toObject(), name: item.name || item.masterIngredient?.name || "Món không tên", image_url: item.image_url || item.masterIngredient?.image || "", category: item.masterIngredient?.category || "Khác", days_left: daysLeft, status_label: statusLabel };
        });
    },
    async updatePantryItem(userId, itemId, updates) {
        if (updates.storage) updates.storage = mapStorageToVietnamese(updates.storage);
        const item = await PantryItem.findOne({ _id: itemId, user: userId });
        if (!item) throw new Error("Item not found");
        Object.keys(updates).forEach((key) => { item[key] = updates[key]; });
        await item.save();
        return item;
    },
    async deletePantryItem(userId, itemId) { return await PantryItem.findOneAndDelete({ _id: itemId, user: userId }); },
    
    // =======================================================
    // 3. GỢI Ý MÓN ĂN (TRỊ BỆNH AI LƯỜI BIẾNG)
    // =======================================================
    async getUserSuggestions(userId, ingredientsInput) {
        let ingredientsListForAI = [];
        let masterIngredientIds = [];
        const TARGET_COUNT = 5; 
        
        // Chuẩn bị dữ liệu nguyên liệu
        if (!ingredientsInput || ingredientsInput.length === 0) {
            const items = await PantryItem.find({ user: userId, quantity: { $gt: 0 } }).populate('masterIngredient', 'name synonyms');
            masterIngredientIds = items.map(item => item.masterIngredient?._id).filter(id => id); 
            ingredientsListForAI = items.map(item => {
                const finalName = item.name || item.masterIngredient?.name || "";
                const synonyms = item.masterIngredient?.synonyms || [];
                if (item.masterIngredient?.name === "Other") return finalName; 
                return finalName + (synonyms.length ? ` (${synonyms.join(', ')})` : "");
            });
        } else {
            for (let item of ingredientsInput) {
                let nameToSearch = typeof item === 'string' ? item : item.name;
                if (nameToSearch) {
                    ingredientsListForAI.push(nameToSearch);
                    const regex = new RegExp(`^${nameToSearch.trim()}$`, 'i');
                    const master = await MasterIngredient.findOne({ $or: [{ name: regex }, { synonyms: regex }] });
                    if (master) masterIngredientIds.push(master._id);
                }
            }
        }

        masterIngredientIds = [...new Set(masterIngredientIds.map(id => id.toString()))];
        console.log("🔍 Ingredients (Names):", ingredientsListForAI);
        
        let finalRecipes = [];

        if (masterIngredientIds.length > 0) {
            const potentialRecipes = await Recipe.find({
                "ingredients.masterIngredient": { $in: masterIngredientIds },
                status: 'Đã duyệt'
            }).lean();

            let suitableDbRecipes = [];

            for (let r of potentialRecipes) {
                let matchCount = 0;
                r.ingredients.forEach(ing => {
                    if (masterIngredientIds.includes(String(ing.masterIngredient))) matchCount++;
                });

                // 🔥 ĐÃ SỬA: Chỉ cần trùng 1 nguyên liệu là cho vào danh sách luôn!
                if (matchCount >= 1) { 
                    suitableDbRecipes.push({
                        _id: r._id,
                        name: r.name,
                        description: r.description,
                        calories: r.nutritionAnalysis?.calories || 0,
                        cooking_time: (r.cookTimeMinutes || 0) + " phút",
                        difficulty: r.difficulty,
                        chef_tips: r.chef_tips || "Món ăn ngon từ cộng đồng!",
                        image_url: r.image || r.imageUrl || "", 
                        ingredients_used: r.ingredients.filter(i => 
                            masterIngredientIds.includes(String(i.masterIngredient))
                        ).map(i => i.name),
                        all_ingredients: r.ingredients.map(i => i.name),
                        steps: r.steps.map(s => s.description),
                        macros: { 
                            protein: r.nutritionAnalysis?.protein || 0,
                            carbs: r.nutritionAnalysis?.carbs || 0,
                            fat: r.nutritionAnalysis?.fat || 0
                        },
                        source: 'Database' 
                    });
                }
            }
            
            // Thuật toán phụ: Xếp hạng món nào xài NHIỀU đồ trong tủ lạnh nhất thì đưa lên đầu
            suitableDbRecipes.sort((a, b) => b.ingredients_used.length - a.ingredients_used.length);
            
            // Cắt đúng 5 món ngon nhất để ném ra ngoài
            finalRecipes = suitableDbRecipes.slice(0, TARGET_COUNT); 
        }

        console.log(`✅ Found ${finalRecipes.length} suitable recipes in DB.`);

        // BƯỚC 2: GỌI AI BÙ ĐẮP (Ép AI không được lười)
        const missingCount = TARGET_COUNT - finalRecipes.length;
        
        if (missingCount > 0) {
            console.log(`🤖 Calling Gemini AI to generate EXACTLY ${missingCount} recipes...`);
            const existingNames = finalRecipes.map(r => r.name).join(", ");
            
            // 🔥 FIX: Nén toàn bộ mảng thành 1 chuỗi và ra Lệnh Cứng cho AI
            const listStr = ingredientsListForAI.join(", ");

            const extraPrompt = existingNames 
                ? `\n- Tuyệt đối không gợi ý lại các món: ${existingNames}.\n- BẮT BUỘC: Gợi ý đúng ${missingCount} món khác.\n- LỆNH TỐI QUAN TRỌNG: Bạn PHẢI sáng tạo các món ăn KẾT HỢP NHIỀU NGUYÊN LIỆU từ danh sách [${listStr}]. Tuyệt đối KHÔNG ĐƯỢC làm biếng chỉ lấy nguyên liệu đầu tiên để tạo ra tất cả các món.`
                : `\n- BẮT BUỘC: Gợi ý đúng ${missingCount} món.\n- LỆNH TỐI QUAN TRỌNG: Bạn PHẢI sáng tạo các món ăn KẾT HỢP NHIỀU NGUYÊN LIỆU từ danh sách [${listStr}]. Tuyệt đối KHÔNG ĐƯỢC làm biếng chỉ lấy nguyên liệu đầu tiên để tạo ra tất cả các món.`;
            
            const prompt = getRecipeSuggestionPrompt(ingredientsListForAI, extraPrompt);
            const result = await model.generateContent(prompt);
            const rawRecipes = cleanAndParseJSON(result.response.text());

            if (rawRecipes && rawRecipes.length > 0) {
                const formattedAiRecipes = rawRecipes.map(r => {
                    let fullDescription = r.description || "";
                    if (r.difficulty) fullDescription += `\n(Độ khó: ${r.difficulty})`;
                    if (r.chef_tips) fullDescription += `\n💡 Mẹo: ${r.chef_tips}`;
                    
                    let cal = parseNumber(r.calories);
                    let time = parseCookingTime(r.cooking_time);
                    if (cal === 0) {
                        const p = parseNumber(r.macros?.protein); const c = parseNumber(r.macros?.carbs); const f = parseNumber(r.macros?.fat);
                        if (p > 0 || c > 0 || f > 0) cal = (p*4) + (c*4) + (f*9); else cal = 350; 
                    }
                    const cleanSteps = (r.steps || []).map(s => (typeof s === 'object') ? (s.description || JSON.stringify(s)) : String(s));
                    
                    return {
                        name: r.name,
                        description: fullDescription, 
                        calories: cal,
                        cooking_time: time + " phút",
                        difficulty: r.difficulty || "Trung bình",
                        chef_tips: r.chef_tips || "",
                        ingredients_used: r.ingredients_used || [],
                        all_ingredients: r.all_ingredients || [],
                        steps: cleanSteps,
                        instructions: cleanSteps, 
                        macros: {
                            protein: parseNumber(r.macros?.protein) || 0,
                            carbs: parseNumber(r.macros?.carbs) || 0,
                            fat: parseNumber(r.macros?.fat) || 0
                        },
                        image_url: r.image_url || "",
                        source: 'AI' 
                    };
                });

                finalRecipes = [...finalRecipes, ...formattedAiRecipes];
            }
        }

        // BƯỚC 3: CẮT GỌT VỀ ĐÚNG 5 MÓN
        if (finalRecipes.length > TARGET_COUNT) {
            finalRecipes = finalRecipes.slice(0, TARGET_COUNT);
        }

        // BƯỚC 4: LƯU LỊCH SỬ
        if (userId && finalRecipes.length > 0) {
            RecipeHistory.create({ 
                user: userId, 
                recipes: finalRecipes 
            }).catch(e => console.error("❌ History Save Error:", e.message));
        }

        return finalRecipes;
    },

    async getHistory(userId) { return await RecipeHistory.find({ user: userId }).sort({ createdAt: -1 }); },
    async clearAllHistory(userId) { return await RecipeHistory.deleteMany({ user: userId }); },
    async deleteHistoryByIds(userId, ids) { return await RecipeHistory.deleteMany({ _id: { $in: ids }, user: userId }); }
};

module.exports = ScanService;