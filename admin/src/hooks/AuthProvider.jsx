{/*TODO: phải tìm hiểu kỹ về file AuthProvider*/}
import { createContext, useContext, useState, useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router"; // Import useNavigate

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate(); // Hook chuyển trang

  // Hàm load user từ token có sẵn (chạy khi F5)
  const loadUser = async () => {
    const token = localStorage.getItem("admin_token") || sessionStorage.getItem("admin_token");
    if (!token) {
        setLoading(false);
        return;
    }

    try {
        const res = await axios.get('/api/admin/auth/me', {
            headers: { 'x-access-token': token }
        });
        if(res.data.success) {
            setUser(res.data.user);
        }
    } catch (err) {
        console.error("Token lỗi", err);
        localStorage.removeItem("admin_token");
        sessionStorage.removeItem("admin_token");
        setUser(null);
    } finally {
        setLoading(false);
    }
  };
  
  const reloadUser = async () => {
    loadUser();
  }

  useEffect(() => {
    loadUser();
  }, []);

  // --- HÀM MỚI: Xử lý đăng nhập ---
  const loginAction = async (token, userData, isRemember) => {
    // 1. Lưu token
    const storage = isRemember ? localStorage : sessionStorage;
    storage.setItem('admin_token', token);
    
    // Xóa ở storage còn lại để tránh trùng
    if (isRemember) sessionStorage.removeItem('admin_token');
    else localStorage.removeItem('admin_token');

    // 2. Cập nhật State ngay lập tức (Quan trọng!)
    setUser(userData); 

    // 3. Chuyển trang (để AuthProvider điều hướng luôn cho chuẩn)
    navigate('/admin'); 
  };

  // --- HÀM MỚI: Xử lý đăng xuất ---
  const logoutAction = () => {
    setUser(null);
    localStorage.removeItem("admin_token");
    sessionStorage.removeItem("admin_token");
    navigate("/admin/signin");
  };

  return (
    // Truyền loginAction và logoutAction xuống dưới
    <AuthContext.Provider value={{ user, loading, loginAction, logoutAction, reloadUser }}>
      {!loading && children} 
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);