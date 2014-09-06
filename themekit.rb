require 'sinatra'
require 'liquid'
require 'active_support/core_ext/string'
require 'json'
require 'hashie'

require_relative 'lib/theme_kit'

before do
  ThemeKit.load
end

get '/' do
  ThemeKit.render 'index.html'
end

get '/news' do
  ThemeKit.render 'news.html', news: ThemeKit.store.news
end

get '/store' do
  ThemeKit.render 'category.html', category: { name: 'All', products: ThemeKit.store.products }
end

get '/products/:slug' do
  ThemeKit.render 'product.html', product: ThemeKit.store.products.find { |p| p.url == request.path_info }
end

get '/artists' do
  ThemeKit.render 'roster.html', roster: ThemeKit.store.roster
end

get '/artists/:artist' do
  item = ThemeKit.store.roster.items.find { |i| i.url == request.path_info }
  item.products = ThemeKit.store.products

  ThemeKit.render 'roster-item.html', item: item
end

get '/contact' do
  ThemeKit.render 'contact.html'
end

get '/stylesheets/:file' do
  content_type :css

  css = File.read(File.join(ThemeKit::PATHS[:stylesheets], params[:file]))
  Liquid::Template.parse(css).render('config' => ThemeKit.config)
end

get '/stylesheets/fonts/:file' do
  send_file File.join(ThemeKit::PATHS[:stylesheets], 'fonts', params[:file])
end

get '/javascripts/:file' do
  send_file File.join(ThemeKit::PATHS[:javascripts], params[:file])
end
