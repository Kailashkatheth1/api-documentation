class FencedCodeBlock < Nanoc3::Filter
  identifier :fenced_code_block

  def run(content, params={})
    content.gsub(/(^`{3}\s*(\S*)\s*$([^`]*)^`{3}\s*$)+?/m) do
      language = $2
      code_block = $3

      replacement  = %{<pre class="highlight"><code class="language}
      replacement << "-#{language}" if language.to_s.length > 0
      replacement << %{">}
      replacement << code_block.gsub("[:backtick:]", "`")
      replacement << %{</code></pre>\n}
    end
  end
end
