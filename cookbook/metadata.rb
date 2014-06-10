name             'runnable_lebowski'
maintainer       'Runnable.com'
maintainer_email 'ben@runnable.com'
license          'All rights reserved'
description      'Installs/Configures lebowski'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

supports 'ubuntu'

depends 'runnable_base'
depends 'apt'
depends 'build-essential'
depends 'nodejs'
depends 'ssh_known_hosts'
depends 'sudo'
depends 'user'

recipe 'runnable_api-server::default', 'Performs installaion/configuration of lebowski and all prerequisites'

attribute 'runnable_lebowski/deploy/deploy_path',
  :display_name => 'deploy path',
  :description => 'The full directory path where lebowski will be deployed',
  :type => 'string',
  :default => '/opt/lebowski'
