class ArticleController < BaseController
  # FRONTOFFICE
  get '/article/:id' do
    article = Article.find_by_id(params[:id])
    haml :article, :locals => { :article => article }
  end

  # BACKOFFICE
  get '/admin/article' do
    articles = Article.all
    haml :'admin/layout', :layout => :'layout'  do
      haml :'admin/article/home', :locals => { :articles => articles }
    end
  end

  get '/admin/article/new' do
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/article/newedit', :locals => { :article => Article.new, :edit => false }
    end
  end

  post '/admin/article/new' do
    article = Article.new
    article.title = params['title']
    article.category = params['category']
    article.short_text = params['short_text']
    article.long_text = params['long_text']
    article.save
    redirect "/admin/article", 303
  end

  get '/admin/article/edit/:id' do
    article = Article.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/article/newedit', :locals => { :article => article, :edit => true }
    end

  end

  post '/admin/article/edit/:id' do
    article = Article.find(params[:id])
    article.title = params['title']
    article.category = params['category']
    article.short_text = params['short_text']
    article.long_text = params['long_text']
    article.save
    redirect "/admin/article", 303
  end

  get '/admin/article/delete/:id' do
    article = Article.find(params[:id])
    haml :'admin/layout', :layout => :'layout' do
      haml :'admin/article/delete', :locals => { :article => article }
    end
  end

  post '/admin/article/delete/:id' do
    Article.destroy(params[:id])
    redirect "/admin/article", 303
  end



end
