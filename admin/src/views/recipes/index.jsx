import React, { useState } from 'react';
// react-bootstrap
import { Row, Col, Table, Badge, Button, Modal, Card, ListGroup, Container } from 'react-bootstrap';
import MainCard from 'components/Card/MainCard';

// icons
import { BiFilter, BiCog, BiPlus, BiTrash, BiShow, BiTimeFive, BiDish, BiUser } from 'react-icons/bi';
import { FaFire, FaUtensils, FaClock } from 'react-icons/fa';

// -----------------------|| MOCK DATA ||-----------------------//
// Dữ liệu giả lập dựa trên Recipe Schema
const mockData = [
  {
    _id: 'r1',
    name: 'Phở Bò Tái Nạm', // name
    image: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80', // image
    author: { 
        _id: 'u1', 
        username: 'Chef Hoang', 
        avatar: 'https://i.pravatar.cc/150?img=12' 
    }, // author (populated)
    servings: '2 người', // servings
    prepTimeMinutes: 45, // prepTimeMinutes
    status: 'approved', // status: 'pending', 'approved', 'rejected'
    
    // --- Thông tin chi tiết (chỉ hiện trong Modal) ---
    ingredients: [
        { userInput: '500g Bánh phở', quantity: 500, unit: 'g', masterIngredient: { name: 'Bánh phở' } },
        { userInput: '300g Thịt bò', quantity: 300, unit: 'g', masterIngredient: { name: 'Thịt bò' } },
        { userInput: 'Hành tây, gừng', quantity: 1, unit: 'củ', masterIngredient: { name: 'Hành tây' } }
    ],
    steps: [
        { description: 'Hầm xương bò trong 2 tiếng để lấy nước dùng.' },
        { description: 'Thái mỏng thịt bò và trần qua nước sôi.' },
        { description: 'Sắp bánh phở ra bát, thêm thịt và chan nước dùng.' }
    ],
    nutritionAnalysis: {
        calories: 450,
        protein: 25,
        carbs: 60,
        fat: 12
    },
    dietTags: [{ name: 'Truyền thống' }],
    cuisineStyleTags: [{ name: 'Món nước' }]
  },
  {
    _id: 'r2',
    name: 'Salad Ức Gà Keto',
    image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    author: { 
        _id: 'u2', 
        username: 'Healthy Anna', 
        avatar: 'https://i.pravatar.cc/150?img=5' 
    },
    servings: '1 người',
    prepTimeMinutes: 15,
    status: 'pending',
    
    ingredients: [
        { userInput: '150g Ức gà luộc', quantity: 150, unit: 'g', masterIngredient: { name: 'Ức gà' } },
        { userInput: 'Xà lách, cà chua bi', quantity: 100, unit: 'g', masterIngredient: { name: 'Rau xà lách' } },
        { userInput: 'Sốt mè rang', quantity: 20, unit: 'ml', masterIngredient: { name: 'Sốt mè' } }
    ],
    steps: [
        { description: 'Ức gà luộc chín, xé nhỏ.' },
        { description: 'Rửa sạch rau củ, cắt vừa ăn.' },
        { description: 'Trộn đều tất cả với sốt.' }
    ],
    nutritionAnalysis: {
        calories: 280,
        protein: 35,
        carbs: 8,
        fat: 10
    },
    dietTags: [{ name: 'Keto' }, { name: 'Low Carb' }],
    cuisineStyleTags: [{ name: 'Salad' }]
  },
  {
    _id: 'r3',
    name: 'Bánh Mì Chảo',
    image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    author: { 
        _id: 'u3', 
        username: 'StreetFood King', 
        avatar: 'https://i.pravatar.cc/150?img=3' 
    },
    servings: '1 người',
    prepTimeMinutes: 20,
    status: 'rejected',
    
    ingredients: [
        { userInput: '1 ổ bánh mì', quantity: 1, unit: 'cái', masterIngredient: { name: 'Bánh mì' } },
        { userInput: '2 trứng ốp la', quantity: 2, unit: 'quả', masterIngredient: { name: 'Trứng gà' } },
        { userInput: 'Pate, xúc xích', quantity: 50, unit: 'g', masterIngredient: { name: 'Pate' } }
    ],
    steps: [
        { description: 'Làm nóng chảo gang.' },
        { description: 'Cho bơ, pate, xúc xích vào đảo.' },
        { description: 'Đập trứng vào, chín tới thì tắt bếp.' }
    ],
    nutritionAnalysis: {
        calories: 600,
        protein: 20,
        carbs: 70,
        fat: 30
    },
    dietTags: [{ name: 'Ăn nhanh' }],
    cuisineStyleTags: [{ name: 'Món đường phố' }]
  },
];

// -----------------------|| COMPONENT ||-----------------------//

export default function RecipeManager() {
  const [showModal, setShowModal] = useState(false);
  const [selectedRecipe, setSelectedRecipe] = useState(null);

  // Xử lý hiển thị trạng thái
  const renderStatusBadge = (status) => {
    switch(status) {
        case 'approved':
            return <Badge bg="success" className="rounded-pill px-3">Đã duyệt</Badge>;
        case 'pending':
            return <Badge bg="warning" text="dark" className="rounded-pill px-3">Chờ duyệt</Badge>;
        case 'rejected':
            return <Badge bg="danger" className="rounded-pill px-3">Từ chối</Badge>;
        default:
            return <Badge bg="secondary">N/A</Badge>;
    }
  };

  const handleShowDetails = (recipe) => {
    setSelectedRecipe(recipe);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedRecipe(null);
  };

  const CustomHeader = (
    <div className="d-flex align-items-center justify-content-between w-100">
      <div className="d-flex align-items-center">
        <span className="mb-0 me-2" style={{ fontWeight: '700', fontSize: '1.125rem' }}>Danh sách Công thức (Recipes)</span>
        <Badge bg="soft-primary" className="rounded-pill px-3 py-1" style={{ backgroundColor: '#e6f0ff', color: '#0d6efd', fontSize: '0.75rem' }}>
          Total: {mockData.length}
        </Badge>
      </div>

      <div className="d-flex gap-2" onClick={(e) => e.stopPropagation()}>
        <Button variant="outline-secondary" size="sm" className="d-flex align-items-center gap-1 border-secondary-subtle text-dark fw-medium">
          <BiFilter size={16} /> Lọc
        </Button>
        <Button variant="primary" size="sm" className="d-flex align-items-center gap-1 ps-3 pe-3 fw-medium">
          <BiPlus size={16} /> Thêm Công thức
        </Button>
      </div>
    </div>
  );

  return (
    <Row>
      <Col sm={12}>
        <MainCard title={CustomHeader}>
          <div className="table-responsive">
            <Table hover className="align-middle mb-0" style={{ minWidth: '800px' }}>
              <thead className="bg-light text-muted">
                <tr>
                  {/* Chỉ hiển thị các trường yêu cầu */}
                  <th className="py-3 ps-3 border-bottom-0">Món ăn (Name & Image)</th>
                  <th className="py-3 border-bottom-0">Tác giả (Author)</th>
                  <th className="py-3 border-bottom-0">Thông tin (Stats)</th>
                  <th className="py-3 border-bottom-0">Trạng thái (Status)</th>
                  <th className="py-3 text-end pe-3 border-bottom-0">Hành động</th>
                </tr>
              </thead>
              <tbody>
                {mockData.map((recipe) => (
                  <tr key={recipe._id} style={{ borderTop: '1px solid #f0f0f0', cursor: 'pointer' }} onClick={() => handleShowDetails(recipe)}>
                    
                    {/* 1. Name & Image */}
                    <td className="py-3 ps-3">
                      <div className="d-flex align-items-center">
                        <img src={recipe.image} alt={recipe.name} className="rounded me-3" style={{ width: '60px', height: '60px', objectFit: 'cover' }} />
                        <div>
                          <h6 className="mb-0 font-weight-bold text-dark">{recipe.name}</h6>
                          <small className="text-muted">ID: {recipe._id}</small>
                        </div>
                      </div>
                    </td>

                    {/* 2. Author */}
                    <td className="py-3">
                      <div className="d-flex align-items-center">
                        <img src={recipe.author.avatar} alt="author" className="rounded-circle me-2" style={{ width: '30px', height: '30px' }} />
                        <span className="text-dark fw-medium">{recipe.author.username}</span>
                      </div>
                    </td>

                    {/* 3. Servings & PrepTimeMinutes */}
                    <td className="py-3">
                      <div className="d-flex flex-column gap-1">
                         <div className="d-flex align-items-center gap-2 text-secondary" style={{fontSize: '0.9rem'}}>
                            <FaUtensils size={12}/> {recipe.servings}
                         </div>
                         <div className="d-flex align-items-center gap-2 text-secondary" style={{fontSize: '0.9rem'}}>
                            <FaClock size={12}/> {recipe.prepTimeMinutes} phút
                         </div>
                      </div>
                    </td>

                    {/* 4. Status */}
                    <td className="py-3">
                        {renderStatusBadge(recipe.status)}
                    </td>

                    {/* Action buttons */}
                    <td className="py-3 text-end pe-3">
                      <div className="d-flex justify-content-end gap-2">
                         <Button variant="light" size="sm" className="text-primary" onClick={(e) => {e.stopPropagation(); handleShowDetails(recipe)}}>
                             <BiShow size={20}/>
                         </Button>
                         <Button variant="light" size="sm" className="text-danger" onClick={(e) => e.stopPropagation()}>
                             <BiTrash size={20}/>
                         </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        </MainCard>

        {/* -----------------------|| RECIPE DETAILS MODAL ||----------------------- */}
        <Modal show={showModal} onHide={handleCloseModal} size="lg" centered>
            {selectedRecipe && (
                <>
                    <Modal.Header closeButton>
                        <Modal.Title>{selectedRecipe.name}</Modal.Title>
                    </Modal.Header>
                    <Modal.Body style={{backgroundColor: '#f8f9fa'}}>
                        <Container fluid className="p-0">
                            <Row className="g-3">
                                {/* Ảnh và Thông tin chung */}
                                <Col md={5}>
                                    <Card className="border-0 shadow-sm h-100">
                                        <Card.Img variant="top" src={selectedRecipe.image} style={{height: '200px', objectFit: 'cover'}} />
                                        <Card.Body>
                                            <div className="mb-3">
                                                {selectedRecipe.dietTags?.map((tag, i) => <Badge key={i} bg="info" className="me-1">{tag.name}</Badge>)}
                                                {selectedRecipe.cuisineStyleTags?.map((tag, i) => <Badge key={i} bg="secondary" className="me-1">{tag.name}</Badge>)}
                                            </div>
                                            <h6 className="fw-bold"><FaFire className="text-danger me-2"/>Dinh dưỡng (Analysis)</h6>
                                            <ListGroup variant="flush" className="small">
                                                <ListGroup.Item className="d-flex justify-content-between px-0">
                                                    <span>Calories</span> <strong>{selectedRecipe.nutritionAnalysis?.calories} kcal</strong>
                                                </ListGroup.Item>
                                                <ListGroup.Item className="d-flex justify-content-between px-0">
                                                    <span>Protein</span> <strong>{selectedRecipe.nutritionAnalysis?.protein}g</strong>
                                                </ListGroup.Item>
                                                <ListGroup.Item className="d-flex justify-content-between px-0">
                                                    <span>Carbs</span> <strong>{selectedRecipe.nutritionAnalysis?.carbs}g</strong>
                                                </ListGroup.Item>
                                                <ListGroup.Item className="d-flex justify-content-between px-0">
                                                    <span>Fat</span> <strong>{selectedRecipe.nutritionAnalysis?.fat}g</strong>
                                                </ListGroup.Item>
                                            </ListGroup>
                                        </Card.Body>
                                    </Card>
                                </Col>

                                {/* Nguyên liệu và Cách làm */}
                                <Col md={7}>
                                    <Card className="border-0 shadow-sm mb-3">
                                        <Card.Header className="bg-white fw-bold text-primary">Nguyên liệu (Ingredients)</Card.Header>
                                        <ListGroup variant="flush">
                                            {selectedRecipe.ingredients.map((item, idx) => (
                                                <ListGroup.Item key={idx} className="d-flex align-items-center">
                                                    <span className="badge bg-light text-dark border me-2">{item.quantity} {item.unit}</span>
                                                    <span>{item.userInput}</span>
                                                </ListGroup.Item>
                                            ))}
                                        </ListGroup>
                                    </Card>

                                    <Card className="border-0 shadow-sm">
                                        <Card.Header className="bg-white fw-bold text-primary">Các bước thực hiện (Steps)</Card.Header>
                                        <Card.Body>
                                            {selectedRecipe.steps.map((step, idx) => (
                                                <div key={idx} className="d-flex mb-3">
                                                    <div className="me-3">
                                                        <span className="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center" style={{width:'24px', height:'24px', fontSize:'0.8rem'}}>
                                                            {idx + 1}
                                                        </span>
                                                    </div>
                                                    <p className="mb-0 small text-secondary">{step.description}</p>
                                                </div>
                                            ))}
                                        </Card.Body>
                                    </Card>
                                </Col>
                            </Row>
                        </Container>
                    </Modal.Body>
                    <Modal.Footer>
                        {selectedRecipe.status === 'pending' && (
                            <>
                                <Button variant="danger">Từ chối</Button>
                                <Button variant="success">Duyệt bài</Button>
                            </>
                        )}
                        <Button variant="secondary" onClick={handleCloseModal}>Đóng</Button>
                    </Modal.Footer>
                </>
            )}
        </Modal>
      </Col>
    </Row>
  );
}