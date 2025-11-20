import React from 'react';
// react-bootstrap
import { Row, Col, Table, Badge, Button } from 'react-bootstrap';
import MainCard from 'components/Card/MainCard';

// icons
import { BiFilter, BiCog, BiPlus, BiTrash, BiEdit, BiShow } from 'react-icons/bi';
import { FaFire, FaDrumstickBite, FaBreadSlice, FaTint } from 'react-icons/fa'; // Icons cho dinh dưỡng

// -----------------------|| MOCK DATA ||-----------------------//
// Dựa trên MasterIngredient Schema 
const mockData = [
  {
    _id: '1',
    name: 'Ức gà (Sống)', // 
    synonyms: ['Thịt ức gà', 'Chicken Breast', 'Phi lê gà'], // 
    image: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    //  nutritionPer100g
    nutritionPer100g: {
      calories: 165, // 
      protein: 31,   // 
      carbs: 0,      // 
      fat: 3.6       // 
    },
    //  tags reference
    tags: [
        { name: 'Thịt', color: 'danger' }, 
        { name: 'Gia cầm', color: 'warning' },
        { name: 'Giàu đạm', color: 'primary' }
    ]
  },
  {
    _id: '2',
    name: 'Gạo lứt',
    synonyms: ['Brown Rice', 'Gạo lức'],
    image: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    nutritionPer100g: {
      calories: 110,
      protein: 2.6,
      carbs: 23,
      fat: 0.9
    },
    tags: [
        { name: 'Ngũ cốc', color: 'success' }, 
        { name: 'Tinh bột', color: 'info' }
    ]
  },
  {
    _id: '3',
    name: 'Súp lơ xanh',
    synonyms: ['Bông cải xanh', 'Broccoli'],
    image: 'https://images.unsplash.com/photo-1583066263725-54d762312b9f?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    nutritionPer100g: {
      calories: 34,
      protein: 2.8,
      carbs: 7,
      fat: 0.4
    },
    tags: [
        { name: 'Rau củ', color: 'success' }, 
        { name: 'Vitamin C', color: 'secondary' }
    ]
  },
  {
    _id: '4',
    name: 'Dầu Oliu',
    synonyms: ['Olive Oil', 'Dầu Olive Extra Virgin'],
    image: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?ixlib=rb-1.2.1&auto=format&fit=crop&w=150&q=80',
    nutritionPer100g: {
      calories: 884,
      protein: 0,
      carbs: 0,
      fat: 100
    },
    tags: [
        { name: 'Chất béo', color: 'warning' }, 
        { name: 'Dầu ăn', color: 'secondary' }
    ]
  },
];

// -----------------------|| COMPONENT ||-----------------------//

export default function MasterIngredientsManager() {

  // Header tùy chỉnh cho MainCard
  const CustomHeader = (
    <div className="d-flex align-items-center justify-content-between w-100">
      <div className="d-flex align-items-center">
        <span className="mb-0 me-2" style={{ fontWeight: '700', fontSize: '1.125rem' }}>Kho Nguyên Liệu Chính (Master Data)</span>
        <Badge bg="soft-primary" className="rounded-pill px-3 py-1" style={{ backgroundColor: '#e6f0ff', color: '#0d6efd', fontSize: '0.75rem' }}>
          Total: {mockData.length}
        </Badge>
      </div>

      <div className="d-flex gap-2" onClick={(e) => e.stopPropagation()}>
        <Button variant="outline-secondary" size="sm" className="d-flex align-items-center gap-1 border-secondary-subtle text-dark fw-medium">
          <BiFilter size={16} /> Lọc
        </Button>
        <Button variant="outline-secondary" size="sm" className="d-flex align-items-center gap-1 border-secondary-subtle text-dark fw-medium">
          <BiCog size={16} /> Cài đặt
        </Button>
        <Button variant="primary" size="sm" className="d-flex align-items-center gap-1 ps-3 pe-3 fw-medium">
          <BiPlus size={16} /> Thêm Nguyên Liệu
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
                  <th className="py-3 ps-3 border-bottom-0">Tên & Tên gọi khác</th>
                  <th className="py-3 border-bottom-0">Phân loại (Tags)</th>
                  <th className="py-3 border-bottom-0" style={{minWidth: '300px'}}>Dinh dưỡng / 100g</th>
                  <th className="py-3 text-end pe-3 border-bottom-0">Hành động</th>
                </tr>
              </thead>
              <tbody>
                {mockData.map((item) => (
                  <tr key={item._id} style={{ borderTop: '1px solid #f0f0f0' }}>
                    
                    {/* Cột 1: Tên và Synonyms  */}
                    <td className="py-3 ps-3">
                      <div className="d-flex align-items-center">
                        <img src={item.image} alt={item.name} className="rounded me-3" style={{ width: '50px', height: '50px', objectFit: 'cover' }} />
                        <div>
                          <h6 className="mb-0 font-weight-bold text-dark">{item.name}</h6>
                          <small className="text-muted d-block text-truncate" style={{maxWidth: '200px'}}>
                            {item.synonyms.join(', ')}
                          </small>
                        </div>
                      </div>
                    </td>

                    {/* Cột 2: Tags (Categories)  */}
                    <td className="py-3">
                      <div className="d-flex flex-wrap gap-1">
                        {item.tags.map((tag, idx) => (
                          <Badge key={idx} bg="light" text={tag.color} className={`rounded border border-${tag.color}-subtle px-2 py-1`} style={{ backgroundColor: 'var(--bs-gray-100)', fontWeight: '500' }}>
                            {tag.name}
                          </Badge>
                        ))}
                      </div>
                    </td>

                    {/* Cột 3: Nutrition Per 100g  */}
                    <td className="py-3">
                      <div className="d-flex align-items-center justify-content-between gap-3">
                        {/* Calories */}
                        <div className="text-center">
                            <div className="d-flex align-items-center gap-1 text-muted mb-1" style={{fontSize: '0.75rem'}}>
                                <FaFire className="text-danger" /> Cal
                            </div>
                            <span className="fw-bold text-dark">{item.nutritionPer100g.calories}</span>
                        </div>
                        
                        <div style={{borderLeft: '1px solid #eee', height: '30px'}}></div>

                        {/* Protein */}
                        <div className="text-center">
                            <div className="d-flex align-items-center gap-1 text-muted mb-1" style={{fontSize: '0.75rem'}}>
                                <FaDrumstickBite className="text-primary" /> Pro
                            </div>
                            <span className="fw-bold text-dark">{item.nutritionPer100g.protein}g</span>
                        </div>

                        {/* Carbs */}
                        <div className="text-center">
                            <div className="d-flex align-items-center gap-1 text-muted mb-1" style={{fontSize: '0.75rem'}}>
                                <FaBreadSlice className="text-warning" /> Carb
                            </div>
                            <span className="fw-bold text-dark">{item.nutritionPer100g.carbs}g</span>
                        </div>

                        {/* Fat */}
                        <div className="text-center">
                            <div className="d-flex align-items-center gap-1 text-muted mb-1" style={{fontSize: '0.75rem'}}>
                                <FaTint className="text-info" /> Fat
                            </div>
                            <span className="fw-bold text-dark">{item.nutritionPer100g.fat}g</span>
                        </div>
                      </div>
                    </td>

                    {/* Cột 4: Hành động */}
                    <td className="py-3 text-end pe-3">
                      <div className="d-flex justify-content-end gap-2 text-secondary">
                        <Button variant="light" size="sm" className="text-primary p-1">
                             <BiShow size={18} />
                        </Button>
                        <Button variant="light" size="sm" className="text-success p-1">
                             <BiEdit size={18} />
                        </Button>
                        <Button variant="light" size="sm" className="text-danger p-1">
                             <BiTrash size={18} />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        </MainCard>
      </Col>
    </Row>
  );
}