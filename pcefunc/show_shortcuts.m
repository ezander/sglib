function show_shortcuts

domNode=xmlread( [prefdir '/shortcuts.xml' ] );
%domstr=parseXML( [prefdir '/shortcuts.xml' ] );
clc
modify( domNode );
1;


function domNode=modify( domNode )

node=domNode;

xml_assert( strcmp( node.getNodeName, '#document'), 'Root''s name is supposed to be #document.' );
xml_assert( node.hasChildNodes, 'Root needs to have at least one child.' );

childNodes = node.getChildNodes;
xml_assert( childNodes.getLength==1, 'There should be exactly 1 child of the root node' );

node=childNodes.item(0);
xml_assert( strcmp( node.getNodeName, 'FAVORITESROOT'), 'FavRoots Name is supposed to be FAVORITESROOT.' );

xml_assert( node.hasChildNodes, 'FavRoot needs to have at least one child.' );
childNodes = node.getChildNodes;
for i=1:childNodes.getLength
    node=childNodes.item(i-1);
    if strcmp( node.getNodeName, 'FAVORITECATEGORY' ) 
        fprintf( '>>%s<<\n', char(node.getNodeName) );
        
        nameNode=node.getChildNodes.item(1);
        xml_assert( strcmp( nameNode.getNodeName, 'name'), 'FavCategories first child is supposed to be ''name''.' );
        name=char(nameNode.getChildNodes.item(0).getData);
        if strcmp( name, 'Toolbar Shortcuts' )
            
        end
    end
end





%     numChildNodes = childNodes.getLength;
%     numChildNodes 
% end


function xml_assert( cond, err ) 
if( ~cond ); error( err ); end


function theStruct = parseXML(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.');
end


% ----- Subfunction PARSECHILDNODES -----
function children = parseChildNodes(theNode)
% Recurse over node children.
children = [];
if theNode.hasChildNodes
   childNodes = theNode.getChildNodes;
   numChildNodes = childNodes.getLength;
   allocCell = cell(1, numChildNodes);

   children = struct(             ...
      'Name', allocCell, 'Attributes', allocCell,    ...
      'Data', allocCell, 'Children', allocCell);

    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end

% ----- Subfunction MAKESTRUCTFROMNODE -----
function nodeStruct = makeStructFromNode(theNode)
% Create structure of node info.

nodeStruct = struct(                        ...
   'Name', char(theNode.getNodeName),       ...
   'Attributes', parseAttributes(theNode),  ...
   'Data', '',                              ...
   'Children', parseChildNodes(theNode));

if any(strcmp(methods(theNode), 'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
   nodeStruct.Data = '';
end

% ----- Subfunction PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

attributes = [];
if theNode.hasAttributes
   theAttributes = theNode.getAttributes;
   numAttributes = theAttributes.getLength;
   allocCell = cell(1, numAttributes);
   attributes = struct('Name', allocCell, 'Value', allocCell);

   for count = 1:numAttributes
      attrib = theAttributes.item(count-1);
      attributes(count).Name = char(attrib.getName);
      attributes(count).Value = char(attrib.getValue);
   end
end
