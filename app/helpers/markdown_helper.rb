module MarkdownHelper
  # Returns the number of greylisted elements or infinity.
  def html_painfulness(html)
    # TODO: these lists should be shared with html_to_markdown's sanitizer

    # These tags can't be converted and may break shit if removed.
    blacklist = %w[col colgroup figcaption figure iframe]
    # These tags can be replaced with their contents without much loss
    greylist = %w[bdo caption cite dfn del figcaption figure hgroup ins kbd q
                  samp small tfoot time var wbr]
    # These tags can either be converted to markdown or used from markdown
    # TODO: actually sanitize using this list after we've done it all
    # NOTE: can we really use dictionary lists and rubies?
    whitelist = %w[a abbr b blockquote br code dd dl dt em h1 h2 h3 h4 h5 h6 i
                   img li mark ol p pre rb rt ruby strike strong sub sup table
                   tbody td th thead tr u ul]

    dom = Nokogiri::HTML.fragment(html)
    return Float::INFINITY if dom.css(blacklist.join(",")).length > 0

    dom.css(greylist.join(",")).length
  end
end
