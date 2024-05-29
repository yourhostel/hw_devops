from diagrams import Diagram, Cluster
from diagrams.aws.compute import EC2
from diagrams.onprem.monitoring import Prometheus, Grafana
from diagrams.onprem.container import Cadvisor
from diagrams.onprem.monitoring import NodeExporter

with Diagram("Ansible Infrastructure", show=False):
    with Cluster("AWS"):
        prometheus_host = EC2("Prometheus")
        grafana_host = EC2("Grafana")

        with Cluster("Node Exporter Hosts"):
            node_exporter_hosts = [EC2("Host 1"),
                                   EC2("Host 2"),
                                   EC2("Host 3")]

        with Cluster("cAdvisor Hosts"):
            cadvisor_hosts = [EC2("Host 1"),
                              EC2("Host 3")]

    prometheus = Prometheus("Prometheus")
    grafana = Grafana("Grafana")
    cadvisor = Cadvisor("cAdvisor")
    node_exporter = NodeExporter("Node Exporter")

    prometheus_host >> prometheus
    grafana_host >> grafana

    for host in node_exporter_hosts:
        host >> node_exporter
        prometheus >> host

    for host in cadvisor_hosts:
        host >> cadvisor
        prometheus >> host
