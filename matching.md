DOESN'T REFLECT CURRENT SYNTAX

matcher ::= utilMatcher | luaMatcher | classMatcher | componentMatcher

utilMatcher ::= anything | allOf | anyOf  
anything ::= **'\_'**  
allOf ::= **'all{'** matcher { **','** matcher } **'}'**  
anyOf ::= **'any{'** matcher { **','** matcher } **'}'**

luaMatcher ::= type | values | table | tostring | tonumber | function  
type ::= **'t.'** typeName  
typeName ::= **'number'** | **'string'** | **'boolean'** | **'table'** | **'function'** | **'thread'** | **'userdata'**  
values ::= **'v{'** value {**','** value } **'}'**  
table ::= **'tbl{'** matcher{ **','** matcher } **'}'**  
tostring ::= **'ts.'** name | **'ts["'** string **'"]'** | **'ts'** stringLiteral  
tonumber ::= **'tn['** number **']'** | **'tn('** number **')'**  
function ::= **'fn'**

classMatcher ::= isClass | isObject | instanceOf | class | subclassOf | superclassOf  
isClass ::= **'is.class'**  
isObject ::= **'is.object'**  
instanceOf ::= **'o.'** classname  
class ::= **'c.'** classname    
subclassOf ::= **'subC.'** classname  
superclassOf ::= **'supC.'** classname

componentMatcher ::= isComponent | isItem | instanceOfComponent |   subcomponentOf | supercomponentOf  
isComponent ::= **'is.component'**  
isItem ::= **'is.item'**  
instanceOfComponent ::= **'it.'** compname  
subcomponentOf ::= **'subCo.'** compname  
supercomponentOf ::= **'supCo.'** compname  
