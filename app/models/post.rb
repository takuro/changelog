class Post < ActiveRecord::Base
  has_many :tag
  validates :title, :body, :raw_body, :permalink, :presence => true
  include ActionView::Helpers::SanitizeHelper

  def remove_html_tag
    self.body = strip_tags self.body
    self.title = strip_tags self.title
  end

  def wiki_syntax_to_html
    wiki_text = self.body.split(/\r?\n/)
    html_text = Array.new
    tmp_str_line = ""
    
    # ブロック記法の開始と終了を記録するために使用
    block_code_started = {
      :precode => false,
      :ul => false,
      :ol => false
    }

    match_regex = Changelog::Application.config.match_regex
    not_match_regex = Changelog::Application.config.not_match_regex
    
    code = "perl"
    wiki_text.each do |text|
      tmp_str_line = text

      if tmp_str_line.blank?
        #next if !block_code_started[:precode]
      end

      # 見出し h5 を変換
      tmp_str_line = wiki_syntax_to_h5(tmp_str_line)
      # 見出し h4 を変換
      tmp_str_line = wiki_syntax_to_h4(tmp_str_line)
      # 見出し h3 を変換
      tmp_str_line = wiki_syntax_to_h3(tmp_str_line)
      # [[文字列:URI]] を <a href="URL">文字列</a> に変換
      tmp_str_line = wiki_syntax_to_link(tmp_str_line)
      # シングルクォーテーション 3 つで囲まれた文字列を <em>...</em> で囲む
      tmp_str_line = wiki_syntax_to_em(tmp_str_line)
      # シングルクォーテーション 2 つで囲まれた文字列を <strong>...</strong> で囲む
      tmp_str_line = wiki_syntax_to_strong(tmp_str_line)
      # #ref(img_src) を img タグに
      tmp_str_line = wiki_syntax_to_img(tmp_str_line)
      # コード種別を取得する
      code = get_code(tmp_str_line)
      next if tmp_str_line =~ Changelog::Application.config.match_regex[:code]

      # 行頭が半角スペースのブロックを<pre><code>...</pre></code>で囲む
      if tmp_str_line =~ match_regex[:precode]
        tmp_str_line = $1
        if !block_code_started[:precode]
          tmp_str_line = "<code class=\"#{code}\"><pre>#{tmp_str_line}"
          block_code_started[:precode] = true
        end
      end

      # 行頭がハイフンのブロックを<ul>...</ul>で囲む
      if tmp_str_line =~ match_regex[:ul]
        tmp_str_line = $1
        if !block_code_started[:ul]
          tmp_str_line = "<ul>\r\n#{tmp_str_line}"
          block_code_started[:ul] = true
        end
      end

      # 行頭がプラスのブロックを<ol>...</ol>で囲む
      if tmp_str_line =~ match_regex[:ol]
        tmp_str_line = $1
        if !block_code_started[:ol]
          tmp_str_line = "<ol>\r\n#{tmp_str_line}"
          block_code_started[:ol] = true
        end
      end

      # ブロック記法に引っかからないテキスト
      # ul
      if text =~ not_match_regex[:ul]
        if block_code_started[:ul]
          tmp_str_line = "</ul>\r\n#{tmp_str_line}"
          block_code_started[:ul] = false
        end
      end

      # ブロック記法に引っかからないテキスト
      # ol
      if text =~ not_match_regex[:ol]
        if block_code_started[:ol]
          tmp_str_line = "</ol>\r\n#{tmp_str_line}"
          block_code_started[:ol] = false
        end
      end

      # ハイフンを li に変換
      tmp_str_line = wiki_syntax_to_ul_li(tmp_str_line)
      # プラスを li に変換
      tmp_str_line = wiki_syntax_to_ol_li(tmp_str_line)

      # ブロック記法に引っかからないテキスト
      # pre と code
      if text =~ not_match_regex[:precode]
        if block_code_started[:precode]
          tmp_str_line = "</pre></code>\r\n#{tmp_str_line}"
          block_code_started[:precode] = false
        end
      end

      html_text << tmp_str_line
    end

    self.body = html_text.join("\r\n")
  end

  def remove_break_return_and_add_br_tag
    self.body = self.body.gsub(/(\r?\n)/, "<br />")
  end

  private

  # 見出し h5 を変換
  def wiki_syntax_to_h5 text
    if text =~ Changelog::Application.config.match_regex[:h5]
      text = "<h5>#{$1}</h5>"
    end
    return text
  end

  # 見出し h4 を変換
  def wiki_syntax_to_h4 text
    if text =~ Changelog::Application.config.match_regex[:h4]
      text = "<h4>#{$1}</h4>"
    end
    return text
  end

  # 見出し h3 を変換
  def wiki_syntax_to_h3 text
    if text =~ Changelog::Application.config.match_regex[:h3]
      text = "<h3>#{$1}</h3>"
    end
    return text
  end

  # [[文字列:URI]] を <a href="URL">文字列</a> に変換
  def wiki_syntax_to_link text
    tmp_scan_array = text.scan(Changelog::Application.config.match_regex[:link]).flatten
    if !tmp_scan_array.blank?
      text = text.sub(Changelog::Application.config.match_regex[:link],
                      "<a href=\"#{tmp_scan_array[1]}\">#{tmp_scan_array[0]}</a>")
    end
    return text
  end

  # シングルクォーテーション 3 つで囲まれた文字列を <em>...</em> で囲む
  def wiki_syntax_to_em text
    tmp_scan_array = text.scan(Changelog::Application.config.match_regex[:em]).flatten
    if !tmp_scan_array.blank?
      tmp_scan_array.each do |tsa|
        text = text.sub(Changelog::Application.config.match_regex[:em], "<em>#{tsa}</em>")
      end
    end
    return text
  end

  # シングルクォーテーション 2 つで囲まれた文字列を <strong>...</strong> で囲む
  def wiki_syntax_to_strong text
    tmp_scan_array = text.scan(Changelog::Application.config.match_regex[:strong]).flatten
    if !tmp_scan_array.blank?
      tmp_scan_array.each do |tsa|
        text = text.sub(Changelog::Application.config.match_regex[:strong], "<strong>#{tsa}</strong>")
      end
    end
    return text
  end

  # #ref(img_src) を img タグに
  def wiki_syntax_to_img text
    if text =~ Changelog::Application.config.match_regex[:img]
      text = "<img src=\"#{$1}\" alt=\"#{$2}\" />"
    end
    return text
  end

  # ハイフンを li に変換
  def wiki_syntax_to_ul_li text
    if text =~ Changelog::Application.config.match_regex[:ul_li]
      list = $1
      if text =~ Changelog::Application.config.match_regex[:ul_tag]
        text = "<ul><li>#{list}</li>"
      else
        text = "<li>#{list}</li>"
      end
    end
    return text
  end

  # プラスを li に変換
  def wiki_syntax_to_ol_li text
    if text =~ Changelog::Application.config.match_regex[:ol_li]
      list = $1
      if text =~ Changelog::Application.config.match_regex[:ol_tag]
        text = "<ol><li>#{list}</li>"
      else
        text = "<li>#{list}</li>"
      end
    end
    return text
  end

  def get_code(text)
    code = "perl"
    if text =~ Changelog::Application.config.match_regex[:code]
      code = $1
    end
    return code
  end

  # @return 保存失敗 -> false
  # @return 保存成功 -> json 文字列
  def self.upload_image image
    upload_dir = Changelog::Application.config.image_upload_dir
    return false unless self.is_image?(image.content_type)
    return false if image.size.to_i > Changelog::Application.config.image_upload_size

    now = Time.now.strftime("%Y%m%d%H%M%S")
    filename = "img-#{now}-#{image.original_filename}"
    begin
      File.open("#{upload_dir}#{filename}", 'wb') do |f|
        f.write(image.read)
      end
    rescue
      return false
    else
      json = "{\"name\":\"#{filename}\","
      json += "\"size\":#{image.size},"
      json += "\"url\":\"#{Changelog::Application.config.image_upload_url}#{filename}\","
      json += "\"type\":\"#{image.content_type}\"}"
      return json
    end
  end

  def self.is_image? mime
    return true if /^image\/.*$/ =~ mime
    return false
  end

end
