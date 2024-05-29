from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.compute import Server
from diagrams.onprem.container import Docker

with Diagram("Ansible Deployment Diagram", show=False):
    with Cluster("AWS cloud"):
        with Cluster("EC2 - The observer"):
            prometheus = Prometheus("Prometheus")
            grafana = Grafana("Grafana")
            node_exporter1 = Server("node-exporter")
            cadvisor1 = Docker("cAdvisor")

        with Cluster("EC2 - Target #1"):
            node_exporter2 = Server("node-exporter")

        with Cluster("EC2 - Target #2"):
            node_exporter3 = Server("node-exporter")
            cadvisor2 = Docker("cAdvisor")

        prometheus >> Edge(color="blue") >> node_exporter1
        prometheus >> Edge(color="blue") >> cadvisor1
        prometheus >> Edge(color="blue") >> node_exporter2
        prometheus >> Edge(color="blue") >> node_exporter3
        prometheus >> Edge(color="blue") >> cadvisor2

        grafana << Edge(color="black") << prometheus



