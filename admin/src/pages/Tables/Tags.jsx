import PageBreadcrumb from "../../components/common/PageBreadCrumb";
import ComponentCard from "../../components/common/ComponentCard";
import PageMeta from "../../components/common/PageMeta";
import BasicTableOne from "../../components/tables/BasicTables/BasicTable";

export default function BasicTables() {
  return (
    <>
      <PageMeta
        title="Thẻ"
        description="Trang thẻ"
      />
      <PageBreadcrumb pageTitle="Thẻ" />
      <div className="space-y-6">
        <ComponentCard title="Thẻ">
          <BasicTableOne />
        </ComponentCard>
      </div>
    </>
  );
}
