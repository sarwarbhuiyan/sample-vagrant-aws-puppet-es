Vagrant.configure(2) do |config|

  access_key_id = ENV['AWS_ACCESS_KEY']
  secret_access_key = ENV['AWS_SECRET_KEY']
  keypair = "sarwar-us-east-1"


  #config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  config.vm.box = "dummy"

  config.librarian_puppet.puppetfile_dir = "puppet"
  # placeholder_filename defaults to .PLACEHOLDER
  config.librarian_puppet.placeholder_filename = ".MYPLACEHOLDER"
  config.librarian_puppet.use_v1_api  = '1' # Check https://github.com/rodjek/librarian-puppet#how-to-use
  config.librarian_puppet.destructive = false # Check https://github.com/rodjek/librarian-puppet#how-to-use

#  config.vm.provision "puppet" do |puppet|
#    puppet.module_path = "puppet/modules"
#    puppet.environment_path = "environments"
#    puppet.environment = "production"
#    puppet.facter = {
      # Exposing these into Facter to allow the Elasticsearch cloud provisioner
      # to use EC2 APIs to find the other nodes
#      :aws_access_key_id => access_key_id,
#      :aws_secret_key    => secret_access_key
#    }
#    puppet.options = "--verbose --debug"
#  end


  # will do a 3 node cluster
  3.times do |number|
    name = "elasticsearch#{number}"
  	
    config.vm.define(name) do |node|
    	node.vm.provider :aws do |aws, override| 
          aws.access_key_id = access_key_id
          aws.secret_access_key = secret_access_key
          aws.keypair_name = keypair
          aws.security_groups = ["sg-52fa0228"]  
          aws.user_data = "#!/bin/sh
echo 'vagrant-#{name}' > /etc/hostname;
hostname 'vagrant-#{name}';"

          # set instance type here
          aws.instance_type = "m4.xlarge"
	  aws.subnet_id = "subnet-ce630c97"
          aws.associate_public_ip = true

          # set EBS block size here
#          aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 50 }]

          # The `node_type` tag will be used in the Elasticsearch AWS plugin
          # configuration to make sure that it only tries to connect to other
          # Elasticsearch nodes
          aws.tags = {
            :node_type => 'elasticsearch',
            :Name => name
          }

	  aws.ami = "ami-6b510f01"

          override.ssh.username = "ubuntu"
          override.ssh.private_key_path = "/Users/sarwar/Downloads/sarwar-us-east-1.pem.txt"
	  node.vm.provision :puppet do |puppet|
             puppet.module_path = "puppet/modules"
    	     puppet.environment_path = "environments"
    	     puppet.environment = "production"
    	     puppet.facter = {
      		# Exposing these into Facter to allow the Elasticsearch cloud provisioner
      		# to use EC2 APIs to find the other nodes
      		:aws_access_key_id => access_key_id,
      		:aws_secret_key    => secret_access_key,
    	    	:node_name => name 
            }
	    puppet.options = "--verbose --debug"

          end        
        end

    end

  end

  0.times do |number|
    name = "kibana#{number}"
    config.vm.define(name) do |node|
        node.vm.provider :aws do |aws, override|
          aws.access_key_id = access_key_id
          aws.secret_access_key = secret_access_key
          aws.keypair_name = keypair

          aws.user_data = "#!/bin/sh
echo 'vagrant-#{name}' > /etc/hostname;
hostname 'vagrant-#{name}';"

          # The `node_type` tag will be used in the Elasticsearch AWS plugin
          # configuration to make sure that it only tries to connect to other
          # Elasticsearch nodes
          aws.tags = {
            :node_type => 'kibana',
            :Name => name
          }

          aws.ami = "ami-6b510f01"

          override.ssh.username = "ubuntu"
          override.ssh.private_key_path = "/Users/sarwar/Downloads/sarwar-us-east-1.pem.txt"

        end

    end
  end

end
