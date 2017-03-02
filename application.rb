require 'sinatra'

require_relative 'apns_form'

get '/' do
  redirect to('/apns')
end

get '/apns' do
  erb :apns
end

post '/apns' do
  @req, @resp = ApnsForm.new(params[:data]).process
  erb :apns
end
