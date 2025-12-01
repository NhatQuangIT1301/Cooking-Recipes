import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import ComponentCard from "../../components/common/ComponentCard";
import PageMeta from "../../components/common/PageMeta";
import BasicTableOne from "../../components/tables/BasicTables/BasicTable";

export default function BasicTables() {
  return (
    <>
      <PageMeta
        title="Công thức"
        description="Trang công thức"
      />
      <PageBreadcrumb pageTitle="Công thức" />
      <div className="space-y-6">
        <ComponentCard title="Công thức">
          <BasicTableOne />
        </ComponentCard>
      </div>
    </>
  );
}
