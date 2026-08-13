class Solution {

    public function suggestedProducts($products, $searchWord) {
        sort($products);
        $res = [];
        $n = strlen($searchWord);
        
        for ($i = 0; $i < $n; $i++) {
            $prefix = substr($searchWord, 0, $i + 1);
            $suggestions = [];
            foreach ($products as $product) {
                if (substr($product, 0, strlen($prefix)) === $prefix) {
                    $suggestions[] = $product;
                    if (count($suggestions) === 3) {
                        break;
                    }
                }
            }
            $res[] = $suggestions;
        }
        
        return $res;
    }
}