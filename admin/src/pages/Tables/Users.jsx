import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import ComponentCard from "../../components/common/ComponentCard";
import PageMeta from "../../components/common/PageMeta";
import BasicTableOne from "../../components/tables/BasicTables/BasicTable";

export default function BasicTables() {
  return (
    <>
      <PageMeta
        title="Người dùng"
        description="Trang người dùng"
      />
      <PageBreadcrumb pageTitle="Người dùng" />
      <div className="space-y-6">
        <ComponentCard title="Người dùng">
          <BasicTableOne />
        </ComponentCard>
      </div>
    </>
  );
}
