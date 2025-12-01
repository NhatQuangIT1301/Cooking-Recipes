import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import ComponentCard from "../../components/common/ComponentCard";
import PageMeta from "../../components/common/PageMeta";
import BasicTableOne from "../../components/tables/BasicTables/BasicTable";

export default function BasicTables() {
  return (
    <>
      <PageMeta
        title="Nguyên liệu"
        description="Trang nguyên liệu"
      />
      <PageBreadcrumb pageTitle="Nguyên liệu" />
      <div className="space-y-6">
        <ComponentCard title="Nguyên liệu">
          <BasicTableOne />
        </ComponentCard>
      </div>
    </>
  );
}
