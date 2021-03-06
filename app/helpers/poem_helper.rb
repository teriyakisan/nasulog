module PoemHelper
  # TODO: 他の箇所でも使うようになったら(コメントとか)
  #       ここじゃない場所に移した方が良さそう
  def markdown(text)
    renderer = Redcarpet::Render::HTML.new
    extensions = {}
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(emojify(text)).html_safe
  end

  def emojify(content)
    return unless content.present?

    h(content).to_str.gsub(/:([\w+-]+):/) do |match|
      emoji_alias = Regexp.last_match(1)
      emoji = Emoji.find_by_alias(emoji_alias)
      if emoji
        %(<img alt="#{emoji_alias}" src="#{image_path("emoji/#{emoji.image_filename}")}" class="emoji" />)
      else
        match
      end
    end.html_safe
  end
end
