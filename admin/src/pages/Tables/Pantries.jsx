import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import ComponentCard from "../../components/common/ComponentCard";
import PageMeta from "../../components/common/PageMeta";
import BasicTableOne from "../../components/tables/BasicTables/BasicTable";

export default function BasicTables() {
  return (
    <>
      <PageMeta
        title="Tủ đồ ăn"
        description="Trang tủ đồ ăn"
      />
      <PageBreadcrumb pageTitle="Tủ đồ ăn" />
      <div className="space-y-6">
        <ComponentCard title="Tủ đồ ăn">
          <BasicTableOne />
        </ComponentCard>
      </div>
    </>
  );
}
