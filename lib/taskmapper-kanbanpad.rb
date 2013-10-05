require File.dirname(__FILE__) + '/kanbanpad/kanbanpad-api'

%w{version kanbanpad ticket project comment api-extensions }.each do |f|
  require File.dirname(__FILE__) + '/provider/' + f + '.rb';
end
