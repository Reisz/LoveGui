matcher ::= anything | allOf | anyOf | type | values | table | classMatcher

anything ::= **''** _(empty string)_

allOf ::= **'all:'** matcher { **'|'** matcher }  
anyOf ::= **'any:'** matcher { **'|'** matcher }

type ::= **'t:'** typeName  
typeName ::= **'number'** | **'string'** | **'boolean'** | **'table'** | **'function'** | **'thread'** | **'userdata'**

values ::= **'v:'** value {**'|'** value }

table ::= **'tbl:'** matcher

classMatcher ::= isClass | isObject | instanceOf | class | subclassOf | superclassOf  
isClass ::= **'is:class'**  
isObject ::= **'is:object'**  
instanceOf ::= **'o:'** classname  
class ::= **'c:'** classname    
subclassOf ::= **'subC:'** classname  
superclassOf ::= **'supC:'** classname

componentMatcher ::= isComponent | isItem | instanceOfComponent |   subcomponentOf | supercomponentOf  
isComponent ::= **'is:component'**  
isItem ::= **'is:item'**  
instanceOfComponent ::= **'it:'** compname  
subcomponentOf ::= **'subCo:'** compname  
supercomponentOf ::= **'supCo:'** compname  
