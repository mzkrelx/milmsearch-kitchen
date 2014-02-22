default['postgresql']['password']['postgres'] = "postgres"

default['postgresql']['version'] = "9.3"
default['postgresql']['dir']         = "/var/lib/pgsql/9.3/data"
default['postgresql']['client']['packages'] = ["postgresql93"]
default['postgresql']['server']['packages'] = ["postgresql93-server"]
default['postgresql']['contrib']['packages'] = ["postgresql93-contrib"]
default['postgresql']['server']['service_name'] = "postgresql-9.3"

default['postgresql']['pg_hba'] = [
  {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'ident'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
  {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
]

default['postgresql']['enable_pgdg_yum'] = true

default['iptables']['templates'] = 'iptables.erb'

default['authorization']['sudo']['include_sudoers_d']  = true
