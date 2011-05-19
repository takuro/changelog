# -*- encoding: utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Changelog
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Tokyo'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # JavaScript files you want as :defaults (application.js is always included).
    config.action_view.javascript_expansions[:defaults] = %w()

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # wiki 記法にマッチさせるための正規表現
    config.match_regex = {
      :precode => /^[\ ](.*)$/, # 行頭が半角スペース -> code と pre で囲む
      :em => /'{3}([^(?:''')]+)'{3}/, # シングルクォーテーション 3 つで囲まれた文字列 -> em
      :strong => /'{2}([^(?:'')]+)'{2}/, # シングルクォーテーション 2 つで囲まれた文字列 -> strong
      :link => /\[{2}(.+):(https?:\/\/.+)\]{2}/, # リンク
      :img => /^\#ref\((.+)\,(.+)\)$/, # 行頭が「 #ref( 」で、間に画像へのURL、末尾に「 ) 」-> 画像 img
      :h5 => /^\*{3}(.*)$/, # 行頭が *** -> 見出し h5
      :h4 => /^\*{2}(.*)$/, # 行頭が ** -> 見出し h4
      :h3 => /^\*{1}(.*)$/, # 行頭が * -> 見出し h3
      :ul => /^([\-].*)$/, # 行頭がハイフン（liに変換前） -> ul
      :ul_li => /^[\-](.*)$/, # 行頭がハイフン -> li
      :ul_tag => /<ul>/, # ul タグにマッチ
      :ol => /^([\+].*)$/, # 行頭がプラス（liに変換前） -> ol
      :ol_li => /^[\+](.*)$/, # 行頭がプラス -> oi
      :ol_tag => /<ol>/, # ol タグにマッチ
      :code => /^\[\[([^:|\[]+)\]\]$/, # ソースコードの種別にマッチ
    }

    # wiki 記法にマッチさせないための正規表現
    config.not_match_regex = {
      :precode => /^[^\ ](.*)$/, # 行頭が半角スペースでない
      :ul => /^[^\-](.*)$/, # 行頭がハイフンでない
      :ol => /^[^\+](.*)$/, # 行頭がプラスでない
    }

    ## ここから下、個別設定
    
    # 管理者の名前（meta タグの Author に反映される）
    config.author = "Takuro Ishii"
    # サイトのタイトル
    config.site_title = "isitkr changelog"
    # サイトの説明
    config.site_description = ""
    # サイトのトップページ URL（ 使用箇所：views/posts/index.rss.builder ）
    config.site_url = "http://isitkr.org/"
    
    # 画像のアップロードディレクトリ URL
    config.image_upload_url = "/images/"
    # 画像のアップロードディレクトリ
    config.image_upload_dir = "#{Rails.root}/public#{config.image_upload_url}"
    # 許可する画像のサイズ（byte単位）
    config.image_upload_size = 200000000

    # サイトの右カラムにユーザアイコンを表示しない場合は、
    #  - config.twitter_userid
    #  - config.twitter
    #  - config.user_icon_url
    # を設定しないで、
    # app/views/layouts/application.html.haml の 35 行目あたりの画像表示部分を
    # コメントアウトしてください。
    #
    # Twitter のユーザ ID
    config.twitter_userid = "isitkr"
    # Twitter へのリンク
    config.twitter = "http://twitter.com/#{config.twitter_userid}"
    # ユーザアイコン URL
    config.user_icon_url = "http://api.twitter.com/1/users/profile_image/#{config.twitter_userid}.json?size=bigger"

    # "Recent logs" に表示する記事数
    config.recent_logs = 5

    # ほかのサイトへのリンク
    config.another_sites = [
      # "サイト名", "サイトへのリンク URL",
      "PHPLab", "http://www7.atpages.jp/phplab/",
      "Tumblr - #{config.twitter_userid}", "http://isitkr.tumblr.com/",
      "Twitter @#{config.twitter_userid}", config.twitter,
      "Github", "https://github.com/takuro",
    ]

  end
end

def d v="raise"
  raise v.inspect
end
