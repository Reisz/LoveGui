#Feature Overview
## Internal Systems
### Component
- Properties
  - Instance only
  - Normal & List Variants
  - Notifies on Chages
  - Can bind to properties and model entries
    - Can also do calculations in bindng
    - `this`, `parent`, `model`, `$()`
  - Type Safety using matchers
- Models
  - Instance only
  - Stored in property
  - Can be array, map or tree
  - Notifies on changes
  - Shared between components, multiple per component
- Relationship
  - Children define functionality of parent
  - Instance only
  - Stored in property
  - List of other components
- Instance Object
  - Clone all property values / bindings
  - Clone all children (recursively)
- Querying
  - Instance only
  - Stored in properties
  - `type` derived from classname
  - `class` list of grouping names (see css)
  - `id` unique per instance (derived from type if not specified)
  - Querying functionality, mass updates

### Item
- Visual Component
- Update & Draw Method
- Animations
- Framebuffer & Shading

### Future: Font Management