from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.compute import Server
from diagrams.onprem.container import Docker

with Diagram("Infrastructure Diagram", show=False):
    with Cluster("VPC: yourhostel"):
        with Cluster("Public Subnets"):
            with Cluster("Instance 1: yourhostel-step-project-3-1"):
                prometheus = Prometheus("Prometheus")
                grafana = Grafana("Grafana")
                cadvisor_1 = Docker("cAdvisor")
                node_exporter_1 = Docker("Node Exporter")

            with Cluster("Instance 2: yourhostel-step-project-3-2"):
                node_exporter_2 = Docker("Node Exporter")

            with Cluster("Instance 3: yourhostel-step-project-3-3"):
                cadvisor_2 = Docker("cAdvisor")
                node_exporter_3 = Docker("Node Exporter")

        prometheus >> Edge(color="blue") << [cadvisor_1, cadvisor_2, node_exporter_1, node_exporter_2, node_exporter_3]
        grafana >> Edge(color="red") << prometheus
