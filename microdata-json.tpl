{* Structured Data Json - LD Microdata for Prestashop 1.6.X & 1.7
*
* Add this code in your smarty global.tpl/header.tpl file to show Organization, WebPage, Website and Product Microdata in ld+json format.
* Requires Prestashop 'productcomments' module for review stars ratings.
* by Ruben Divall @rubendivall http://www.rubendivall.com 
* Module by @atomiksoft: https://addons.prestashop.com/en/seo-natural-search-engine-optimization/24511-microformats-in-ldjson.html
*}
{* Edited for Prestshop 1.7.x
<script type="application/ld+json">
{
    "@context" : "http://schema.org",
    "@type" : "Organization",
    "name" : "{$shop.name|escape:'html':'UTF-8'}",
    "url" : "{$page.canonical|escape:'html':'UTF-8'}",
    "logo" : {
        "@type":"ImageObject",
        "url":"{$shop.logo|escape:'html':'UTF-8'}"
    }
}
</script>
<script type="application/ld+json">
{
    "@context":"http://schema.org",
    "@type":"WebPage",
    "isPartOf": {
        "@type":"WebSite",
        "url":  "{$page.canonical|escape:'html':'UTF-8'}",
        "name": "{$shop.name|escape:'html':'UTF-8'}"
    },
    "name": "{$page.meta.title|escape:'html':'UTF-8'}",
    "url":  "{$page.canonical}"
}
</script>
{if $page.page_name =='index'}
<script	type="application/ld+json">
{
	"@context":	"http://schema.org",
	"@type": "WebSite",
	"url": "{$page.canonical|escape:'html':'UTF-8'}",
	"image": {
	"@type": "ImageObject",
	"url":  "{$shop.logo|escape:'html':'UTF-8'}"
	},
    "potentialAction": {
    "@type": "SearchAction",
    "target": "{'--search_term_string--'|str_replace:'{search_term_string}':$link->getPageLink('search',true,null,['search_query'=>'--search_term_string--'])}",
     "query-input": "required name=search_term_string"
	 }
}
</script>
{/if}
{if $page.page_name == 'product'}
<script type="application/ld+json">
    {
    "@context": "http://schema.org/",
    "@type": "Product",
    "name": "{$product->name|escape:'html':'UTF-8'}",
    "description": "{$product->description_short|strip_tags|escape:'html':'UTF-8'}",
	{if $product->reference}"mpn": "{$product->id|escape:'html':'UTF-8'}",{/if}
    {if $product_manufacturer->name}"brand": {
        "@type": "Thing",
        "name": "{$product_manufacturer->name|escape:'html':'UTF-8'}"
    },{/if}
    {if isset($nbComments) && $nbComments && $ratings.avg}"aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "{$ratings.avg|round:1|escape:'html':'UTF-8'}",
        "reviewCount": "{$nbComments|escape:'html':'UTF-8'}"
    },{/if}
    {if empty($combinations)}
    "offers": {
        "@type": "Offer",
        "priceCurrency": "{$currency.iso_code|escape:'html':'UTF-8'}",
        "name": "{$product->name|escape:'html':'UTF-8'}",
        "price": "{$product->getPrice(true, $smarty.const.NULL, 2)|round:'2'|escape:'html':'UTF-8'}",
        "image": "{$link->getImageLink($product->link_rewrite, $product->id_default_image, 'home_default')|escape:'html':'UTF-8'}",
        {if $product->ean13}
        "gtin13": "{$product->ean13|escape:'html':'UTF-8'}",
        {else if $product->upc}
        "gtin13": "0{$product->upc|escape:'html':'UTF-8'}",
        {/if}
        "sku": "{$product->reference}",
        {if $product->condition == 'new'}"itemCondition": "http://schema.org/NewCondition",{/if}
        {if $product->condition == 'used'}"itemCondition": "http://schema.org/UsedCondition",{/if}
        {if $product->condition == 'refurbished'}"itemCondition": "http://schema.org/RefurbishedCondition",{/if}
        "availability":{if $product->quantity > 0} "http://schema.org/InStock"{else} "http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$shop_name|escape:'html':'UTF-8'}"
        }
    }
    {else}
    "offers": [
      {foreach key=id_product_combination item=combination from=$combinations}
        {
        "@type": "Offer",
        "name": "{$product->name|escape:'html':'UTF-8'} - {$combination.reference}",
        "priceCurrency": "{$currency.iso_code|escape:'html':'UTF-8'}",
        "price": "{Product::getPriceStatic($product->id, true, $id_product_combination)|round:'2'}",
        "image": "{if $combination.id_image > 0}{$link->getImageLink($product->link_rewrite, $combination.id_image, 'home_default')|escape:'html':'UTF-8'}{else}{$link->getImageLink($product->link_rewrite, $combination.id_image, 'home_default')|escape:'html':'UTF-8'}{/if}",
        {if $combination.reference}
        "gtin13": "{$combination.reference|escape:'html':'UTF-8'}",
        {/if}
        "sku": "{$combination.reference}",
        "item
        "itemCondition": "http://schema.org/NewCondition",
        "availability": {if $combination.quantity > 0}"http://schema.org/InStock"{else}"http://schema.org/OutOfStock"{/if},
        "seller": {
            "@type": "Organization",
            "name": "{$shop.name|escape:'html':'UTF-8'}"}
        } {if !$combination@last},{/if}          
     {/foreach}
    ]
    {/if}
}
</script>
{/if}
{** End of Structured Data Json - LD Microdata for Prestashop 1.6.X **}
