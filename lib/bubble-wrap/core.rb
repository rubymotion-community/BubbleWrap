BubbleWrap.require('app/core.rb')
BubbleWrap.require('app/core/**/*.rb') do 
  file('app/core/device/screen.rb').depends_on 'app/core/device.rb'
  file('app/core/pollute.rb').depends_on 'app/core/ns_index_path.rb'
  file('app/core/pollute.rb').depends_on 'app/core/ui_control.rb'
end
