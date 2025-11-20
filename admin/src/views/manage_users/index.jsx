import React, { useState } from 'react';
// react-bootstrap
import { Row, Col, Table, Badge, Button, Modal, Container } from 'react-bootstrap';
import MainCard from 'components/Card/MainCard';

// icons
import { BiFilter, BiCog, BiPlus, BiTrash, BiShow, BiMaleSign, BiFemaleSign, BiBody } from 'react-icons/bi';
import { FaUserShield, FaUser } from 'react-icons/fa';

// -----------------------|| MOCK DATA ||-----------------------//
// Giả lập dữ liệu trả về từ API: User.find().populate('profile')
// Dựa trên User Schema [cite: 35] và UserProfile Schema [cite: 38]
const mockData = [
  {
    _id: 'u1',
    username: 'nguyenvana',
    email: 'nguyenvana@example.com',
    phone: '0901234567',
    isAdmin: true, // User Schema: isAdmin
    avatar: 'https://i.pravatar.cc/150?img=11',
    // UserProfile Data (đã populate)
    profile: {
      height: 175, // cm
      weightHistory: [{ value: 70, date: '2023-01-01' }, { value: 68, date: '2023-02-01' }], // Lấy cân nặng mới nhất
      gender: 'male',
      birthDate: '1995-05-20',
      nutritionGoal: { name: 'Tăng cơ' }, // Tag Schema
      diet: { name: 'Không ăn chay' },     // Tag Schema
      healthConditions: [{ name: 'Dị ứng lạc' }], // Tag Schema
      habits: ['Ăn khuya', 'Uống ít nước']
    }
  },
  {
    _id: 'u2',
    username: 'lethib',
    email: 'lethib@example.com',
    phone: null, // sparse: true cho phép null
    isAdmin: false,
    avatar: 'https://i.pravatar.cc/150?img=5',
    profile: {
      height: 160,
      weightHistory: [{ value: 50, date: '2023-06-15' }],
      gender: 'female',
      birthDate: '2000-10-10',
      nutritionGoal: { name: 'Giảm cân' },
      diet: { name: 'Keto' },
      healthConditions: [],
      habits: ['Tập yoga sáng']
    }
  },
  {
    _id: 'u3',
    username: 'tranc',
    email: 'tranc_dev@example.com',
    phone: '0912345678',
    isAdmin: false,
    avatar: 'https://i.pravatar.cc/150?img=3',
    profile: {
      height: 180,
      weightHistory: [{ value: 85, date: '2023-01-01' }],
      gender: 'other',
      birthDate: '1990-12-05',
      nutritionGoal: { name: 'Duy trì cân nặng' },
      diet: { name: 'Thuần chay' },
      healthConditions: [{ name: 'Tiểu đường' }, { name: 'Huyết áp cao' }],
      habits: []
    }
  },
];

// -----------------------|| COMPONENT ||-----------------------//

export default function ManageUsers() {
  const [showModal, setShowModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);

  // Hàm mở popup chi tiết
  const handleShowDetails = (user) => {
    setSelectedUser(user);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedUser(null);
  };

  // Tính tuổi từ ngày sinh
  const calculateAge = (birthDate) => {
    if (!birthDate) return 'N/A';
    const today = new Date();
    const birth = new Date(birthDate);
    let age = today.getFullYear() - birth.getFullYear();
    const m = today.getMonth() - birth.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birth.getDate())) {
      age--;
    }
    return age;
  };

  // Lấy cân nặng mới nhất
  const getCurrentWeight = (history) => {
    if (!history || history.length === 0) return 'N/A';
    return history[history.length - 1].value; // Lấy phần tử cuối mảng
  };

  const CustomHeader = (
    <div className="d-flex align-items-center justify-content-between w-100">
      <div className="d-flex align-items-center">
        <span className="mb-0 me-2" style={{ fontWeight: '700', fontSize: '1.125rem' }}>Quản lý Người dùng</span>
        <Badge bg="soft-primary" className="rounded-pill px-3 py-1" style={{ backgroundColor: '#e6f0ff', color: '#0d6efd', fontSize: '0.75rem' }}>
          Total: {mockData.length}
        </Badge>
      </div>
      <div className="d-flex gap-2" onClick={(e) => e.stopPropagation()}>
        <Button variant="outline-secondary" size="sm" className="d-flex align-items-center gap-1 border-secondary-subtle text-dark fw-medium">
          <BiFilter size={16} /> Lọc
        </Button>
        <Button variant="primary" size="sm" className="d-flex align-items-center gap-1 ps-3 pe-3 fw-medium">
          <BiPlus size={16} /> Thêm Admin
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
                  {/* Cập nhật THEAD theo User Schema */}
                  <th className="py-3 ps-3 border-bottom-0">Người dùng (User Info)</th>
                  <th className="py-3 border-bottom-0">Liên hệ (Contact)</th>
                  <th className="py-3 border-bottom-0">Vai trò (Role)</th>
                  <th className="py-3 border-bottom-0">Trạng thái Profile</th>
                  <th className="py-3 text-end pe-3 border-bottom-0">Hành động</th>
                </tr>
              </thead>
              <tbody>
                {mockData.map((user) => (
                  <tr key={user._id} style={{ borderTop: '1px solid #f0f0f0', cursor: 'pointer' }} onClick={() => handleShowDetails(user)}>
                    <td className="py-3 ps-3">
                      <div className="d-flex align-items-center">
                        <img src={user.avatar} alt={user.username} className="rounded-circle me-3" style={{ width: '45px', height: '45px', objectFit: 'cover' }} />
                        <div>
                          <h6 className="mb-0 font-weight-bold text-dark">{user.username}</h6>
                          <small className="text-muted">ID: {user._id}</small>
                        </div>
                      </div>
                    </td>
                    <td className="py-3">
                      <div className="d-flex flex-column">
                        <span className="text-dark fw-medium">{user.email}</span>
                        <small className="text-muted">{user.phone || 'Chưa cập nhật'}</small>
                      </div>
                    </td>
                    <td className="py-3">
                       {/* User Schema: isAdmin field */}
                      {user.isAdmin ? (
                        <Badge bg="primary" className="d-inline-flex align-items-center gap-1 px-3 py-2 rounded-pill">
                           <FaUserShield /> Admin
                        </Badge>
                      ) : (
                        <Badge bg="light" text="secondary" className="d-inline-flex align-items-center gap-1 px-3 py-2 rounded-pill border">
                           <FaUser /> Member
                        </Badge>
                      )}
                    </td>
                    <td className="py-3">
                      {/* Check xem có profile chưa */}
                      {user.profile ? (
                         <span className="text-success fw-bold" style={{fontSize: '0.85rem'}}>● Đã cập nhật</span>
                      ) : (
                         <span className="text-danger fw-bold" style={{fontSize: '0.85rem'}}>○ Chưa có HS</span>
                      )}
                    </td>
                    <td className="py-3 text-end pe-3">
                      <div className="d-flex justify-content-end gap-2">
                        <Button variant="light" size="sm" className="text-primary" onClick={(e) => { e.stopPropagation(); handleShowDetails(user); }}>
                            <BiShow size={20} />
                        </Button>
                        <Button variant="light" size="sm" className="text-danger" onClick={(e) => e.stopPropagation()}>
                            <BiTrash size={20} />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
        </MainCard>

        {/* -----------------------|| USER PROFILE MODAL ||----------------------- */}
        {/* Hiển thị thông tin chi tiết từ UserProfile Schema */}
        <Modal show={showModal} onHide={handleCloseModal} size="lg" centered>
          <Modal.Header closeButton>
            <Modal.Title className="d-flex align-items-center gap-3">
                {selectedUser && (
                    <>
                        <img src={selectedUser.avatar} alt="avatar" className="rounded-circle" style={{width: '50px', height: '50px'}} />
                        <div>
                            <h5 className="mb-0">{selectedUser.username}</h5>
                            <small className="text-muted fw-normal">{selectedUser.email}</small>
                        </div>
                    </>
                )}
            </Modal.Title>
          </Modal.Header>
          <Modal.Body className="bg-light">
            {selectedUser && selectedUser.profile ? (
                <Container fluid>
                    <Row className="g-3">
                        {/* Chỉ số cơ thể */}
                        <Col md={6}>
                            <div className="bg-white p-3 rounded shadow-sm h-100">
                                <h6 className="text-primary mb-3 d-flex align-items-center gap-2">
                                    <BiBody /> Chỉ số cơ thể
                                </h6>
                                <div className="d-flex justify-content-between mb-2 border-bottom pb-2">
                                    <span className="text-muted">Giới tính:</span>
                                    <span className="fw-medium text-capitalize">
                                        {selectedUser.profile.gender === 'male' ? <><BiMaleSign className="text-primary"/> Nam</> : 
                                         selectedUser.profile.gender === 'female' ? <><BiFemaleSign className="text-danger"/> Nữ</> : 'Khác'}
                                    </span>
                                </div>
                                <div className="d-flex justify-content-between mb-2 border-bottom pb-2">
                                    <span className="text-muted">Tuổi:</span>
                                    <span className="fw-medium">{calculateAge(selectedUser.profile.birthDate)}</span>
                                </div>
                                <div className="d-flex justify-content-between mb-2 border-bottom pb-2">
                                    <span className="text-muted">Chiều cao:</span>
                                    <span className="fw-medium">{selectedUser.profile.height} cm</span>
                                </div>
                                <div className="d-flex justify-content-between">
                                    <span className="text-muted">Cân nặng hiện tại:</span>
                                    <span className="fw-medium">{getCurrentWeight(selectedUser.profile.weightHistory)} kg</span>
                                </div>
                            </div>
                        </Col>

                        {/* Mục tiêu & Chế độ */}
                        <Col md={6}>
                            <div className="bg-white p-3 rounded shadow-sm h-100">
                                <h6 className="text-success mb-3 d-flex align-items-center gap-2">
                                    <BiFilter /> Chế độ & Mục tiêu
                                </h6>
                                <div className="mb-3">
                                    <label className="d-block text-muted small mb-1">Mục tiêu dinh dưỡng:</label>
                                    <Badge bg="info" className="px-3 py-2">{selectedUser.profile.nutritionGoal?.name || 'Chưa đặt'}</Badge>
                                </div>
                                <div className="mb-3">
                                    <label className="d-block text-muted small mb-1">Chế độ ăn (Diet Type):</label>
                                    <Badge bg="success" className="px-3 py-2">{selectedUser.profile.diet?.name || 'Chưa đặt'}</Badge>
                                </div>
                                <div>
                                    <label className="d-block text-muted small mb-1">Tình trạng sức khỏe:</label>
                                    <div className="d-flex flex-wrap gap-1">
                                        {selectedUser.profile.healthConditions && selectedUser.profile.healthConditions.length > 0 ? (
                                            selectedUser.profile.healthConditions.map((tag, idx) => (
                                                <Badge key={idx} bg="danger" bg-opacity="10" className="text-danger border border-danger-subtle">
                                                    {tag.name}
                                                </Badge>
                                            ))
                                        ) : <span className="text-muted small">Không có</span>}
                                    </div>
                                </div>
                            </div>
                        </Col>

                         {/* Thói quen */}
                         <Col md={12}>
                            <div className="bg-white p-3 rounded shadow-sm">
                                <h6 className="text-secondary mb-3">Thói quen (Habits)</h6>
                                <div className="d-flex flex-wrap gap-2">
                                    {selectedUser.profile.habits && selectedUser.profile.habits.length > 0 ? (
                                        selectedUser.profile.habits.map((habit, idx) => (
                                            <Badge key={idx} bg="secondary" className="fw-normal px-3 py-2">
                                                {habit}
                                            </Badge>
                                        ))
                                    ) : <span className="text-muted font-italic">Chưa ghi nhận thói quen nào.</span>}
                                </div>
                            </div>
                         </Col>
                    </Row>
                </Container>
            ) : (
                <div className="text-center py-5 text-muted">
                    <p>Người dùng này chưa cập nhật hồ sơ sức khỏe (UserProfile).</p>
                </div>
            )}
          </Modal.Body>
          <Modal.Footer>
            <Button variant="secondary" onClick={handleCloseModal}>Đóng</Button>
            {selectedUser && selectedUser.profile && (
                 <Button variant="primary"><BiCog className="me-1"/> Chỉnh sửa hồ sơ</Button>
            )}
          </Modal.Footer>
        </Modal>
      </Col>
    </Row>
  );
}