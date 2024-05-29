from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.compute import Server
from diagrams.onprem.container import Docker
from diagrams.onprem.network import Internet

with Diagram("Ansible Deployment Diagram", show=False):
    with Cluster("AWS Instances"):
        prometheus = Prometheus("Prometheus")
        grafana = Grafana("Grafana")
        cadvisor1 = Docker("cAdvisor")
        node_exporter1 = Server("Node Exporter")
        node_exporter2 = Server("Node Exporter")
        cadvisor2 = Docker("cAdvisor")

    internet = Internet("Internet")

    internet >> Edge(label="Access via HTTP/HTTPS") >> prometheus
    prometheus >> grafana
    prometheus >> node_exporter1
    prometheus >> node_exporter2
    prometheus >> cadvisor1
    prometheus >> cadvisor2

