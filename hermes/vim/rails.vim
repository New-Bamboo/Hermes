" Set up some useful Rails.vim bindings for working with Backbone.js
" based on https://github.com/r00k/dotfiles/blob/master/vimrc#L284
autocmd User Rails Rnavcommand template    app/assets/templates               -glob=**/*  -suffix=.jst.ejs
autocmd User Rails Rnavcommand decorator   app/decorators                     -glob=**/*  -suffix=.rb
autocmd User Rails Rnavcommand jmodel      app/assets/javascripts/models      -glob=**/*  -suffix=.js.coffee
autocmd User Rails Rnavcommand jview       app/assets/javascripts/views       -glob=**/*  -suffix=.js.coffee
autocmd User Rails Rnavcommand jcollection app/assets/javascripts/collections -glob=**/*  -suffix=.js.coffee
autocmd User Rails Rnavcommand jrouter     app/assets/javascripts/routers     -glob=**/*  -suffix=.js.coffee
autocmd User Rails Rnavcommand jspec       spec/javascripts                   -glob=**/*  -suffix=.js.coffee

" app to spec and back - https://github.com/tpope/vim-rails/issues/142#issuecomment-3821756
autocmd User Rails/app/assets/javascripts/*/*.js.coffee let b:rails_alternate = substitute(substitute(rails#buffer().path(), 'app/assets', 'spec', ''), '\.js\.coffee', '_spec.js.coffee', '')
autocmd User Rails/spec/javascripts/*/*.js.coffee let b:rails_alternate = substitute(substitute(rails#buffer().path(), 'spec/javascripts', 'app/assets/javascripts', ''), '_spec\.js\.coffee', '.js.coffee', '')
