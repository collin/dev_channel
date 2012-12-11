Rails.application.routes.draw do

  mount DevChannel::Engine => "/dev_channel"
end
