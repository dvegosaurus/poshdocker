
$list = (1..100) | % {[char]($_)}
$string = ""
foreach ($i in (1..10)){
    
    $string += get-random $list 
}
[PSCustomObject]@{
    type = "password"
    value = $string
} | convertto-yaml
