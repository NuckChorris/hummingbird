VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'hummingbird-trusty'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box'

  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: "192.168.121.100"


  #######
  # Setup the OS
  ####
  # Add the repos
  config.vm.provision :shell, :inline => <<-REPOSITORIES
    add-apt-repository -y ppa:pitti/postgresql 2>&1 >/dev/null &&\
    wget -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add - &&\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main\n" > /etc/apt/sources.list.d/pgdg.list &&\
    echo "Package: *\nPin: release o=apt.postgresql.org\nPin-Priority: 500\n" > /etc/apt/preferences.d/pgdg.pref &&\
    apt-get -qq -y update
  REPOSITORIES

  # Install packages and RVM
  config.vm.provision :shell, :inline => <<-PACKAGES
    apt-get -qq -y install ntp curl build-essential libcurl4-openssl-dev libmysqlclient-dev \\
                           libreadline-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev \\
                           libpq-dev libpq5 python-psycopg2 pgdg-keyring postgresql-9.2 \\
                           postgresql-contrib-9.2 git &&\
    curl -L https://get.rvm.io | bash -s stable --ruby=2.1.0
  PACKAGES

  # Load the database
  config.vm.provision :shell, :inline => <<-DATABASE
    echo "CREATE USER hummingbird_dev;" | sudo -u postgres psql
  DATABASE

  #######
  # Setup the Codebase
  ####
  # Bundle Install
  config.vm.provision :shell, :inline => "cd /vagrant && bundle install"
  # Start with foreman
  config.vm.provision :shell, :inline => "cd /vagrant && bundle exec foreman start"
end
