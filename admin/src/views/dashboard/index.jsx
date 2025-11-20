// react-bootstrap
import { Row, Col, Card } from 'react-bootstrap';

// third party
import Chart from 'react-apexcharts';

// project imports
import FlatCard from 'components/Widgets/Statistic/FlatCard';
import ProductCard from 'components/Widgets/Statistic/ProductCard';
import FeedTable from 'components/Widgets/FeedTable';
import PendingTable from '../../components/Widgets/PendingTable';
import SaveTable from 'components/Widgets/SaveTable';
import { SalesAccountChartData } from './chart/sales-account-chart';
import feedData from 'data/feedData';
import productData from 'data/productTableData';
import productData1 from 'data/productTableData1';

// -----------------------|| DASHBOARD SALES ||-----------------------//
export default function DashSales() {
  return (
    <Row>
        <Card className="flat-card">
          <div className="row-table">
            <Card.Body className="col-sm-6 br">
              <FlatCard params={{ title: 'Tổng số người dùng', iconClass: 'text-primary mb-1', icon: 'group', value: '1000' }} />
            </Card.Body>
            <Card.Body className="col-sm-6 d-none d-md-table-cell d-lg-table-cell d-xl-table-cell card-body br">
              <FlatCard params={{ title: 'Tổng số công thức', iconClass: 'text-primary mb-1', icon: 'language', value: '1252' }} />
            </Card.Body>
            <Card.Body className="col-sm-6 card-bod">
              <FlatCard params={{ title: 'Tổng số nguyên liệu', iconClass: 'text-primary mb-1', icon: 'unarchive', value: '2600' }} />
            </Card.Body>
          </div>
          <div className="row-table">
            <Card.Body className="col-sm-6 br">
              <FlatCard
                params={{
                  title: 'Returns',
                  iconClass: 'text-primary mb-1',
                  icon: 'swap_horizontal_circle',
                  value: '3550'
                }}
              />
            </Card.Body>
            <Card.Body className="col-sm-6 d-none d-md-table-cell d-lg-table-cell d-xl-table-cell card-body br">
              <FlatCard params={{ title: 'Downloads', iconClass: 'text-primary mb-1', icon: 'cloud_download', value: '3550' }} />
            </Card.Body>
            <Card.Body className="col-sm-6 card-bod">
              <FlatCard params={{ title: 'Order', iconClass: 'text-primary mb-1', icon: 'shopping_cart', value: '100%' }} />
            </Card.Body>
          </div>
        </Card>
      <Col md={12} xl={6}>
        <Card>
          <Card.Header>
            <h5>Số lượng người dùng</h5>
          </Card.Header>
          <Card.Body>
            <Row className="pb-2">
              <div className="col-auto m-b-10">
                <h3 className="mb-1">1233</h3>
                <span>Cả năm</span>
              </div>
              <div className="col-auto m-b-10">
                <h3 className="mb-1">102.75</h3>
                <span>Tháng</span>
              </div>
            </Row>
            <Chart {...SalesAccountChartData()} />
          </Card.Body>
        </Card>
      </Col>

      <Col md={12} xl={6}>
        {/* Feed Table */}
        <FeedTable {...feedData} />
      </Col>
      
      <Col md={12} xl={6}>
        <PendingTable {...productData} />
      </Col>

      <Col md={12} xl={6}>
        <SaveTable {...productData1} />
      </Col>

    </Row>
  );
}
