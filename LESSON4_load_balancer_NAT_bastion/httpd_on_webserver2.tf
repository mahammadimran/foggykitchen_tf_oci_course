resource "null_resource" "FoggyKitchenWebserver2HTTPD" {
 depends_on = [oci_core_instance.FoggyKitchenWebserver2,oci_core_instance.FoggyKitchenBastionServer]
 provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver2_VNIC1.private_ip_address
                private_key = tls_private_key.public_private_key_pair.private_key_pem
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
                bastion_host = data.oci_core_vnic.FoggyKitchenBastionServer_VNIC1.public_ip_address
                bastion_port = "22"
                bastion_user = "opc"
                bastion_private_key = tls_private_key.public_private_key_pair.private_key_pem
        }
  inline = ["echo '== 1. Installing HTTPD package with yum'",
            "sudo -u root yum -y -q install httpd",

            "echo '== 2. Creating /var/www/html/index.html'",
            "sudo -u root touch /var/www/html/index.html", 
            "sudo /bin/su -c \"echo 'Welcome to FoggyKitchen.com! This is WEBSERVER2...' > /var/www/html/index.html\"",

            "echo '== 3. Disabling firewall and starting HTTPD service'",
            "sudo -u root service firewalld stop",
            "sudo -u root service httpd start"]
  }
}
