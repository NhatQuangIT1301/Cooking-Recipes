import { Navigate } from "react-router";

export default function ProtectedRoute({ children }) {
    const token = localStorage.getItem("admin_token") || sessionStorage.getItem("admin_token");
    const isAuthenticated =  token && token !== "";

    if (!isAuthenticated) {
        // 3. Thêm thuộc tính `replace`
        // `replace`: Giúp xóa lịch sử duyệt web, để khi user bấm nút Back
        // họ không bị quay lại trang admin rồi lại bị đá ra login (vòng lặp vô tận).
        return <Navigate to="/admin/signin" replace/>;    
    }
    return children;
}