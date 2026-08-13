# @param {String[]} products
# @param {String} search_word
# @return {String[][]}
def suggested_products(products, search_word)
    sorted = products.sort
    result = []
    (0...search_word.length).each do |i|
        prefix = search_word[0..i]
        suggestions = []
        sorted.each do |p|
            if p.start_with?(prefix)
                suggestions << p
                break if suggestions.length == 3
            end
        end
        result << suggestions
    end
    result
end
