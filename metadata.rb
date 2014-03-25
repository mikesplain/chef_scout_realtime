name             'chef_scout_realtime'
maintainer       'Mike Splain'
maintainer_email 'mike.splain@gmail.com'
license          'All rights reserved'
description      'chef scout_realtime Cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'


%w{ centos redhat debian ubuntu amazon }.each do |os|
  supports os
end
