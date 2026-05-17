## ADDED Requirements

### Requirement: Fork MUST preserve Apache-2.0 legal notices
The fork MUST include the Apache-2.0 license text and MUST preserve upstream copyright and attribution notices that apply to redistributed source and artifacts.

#### Scenario: Repository source distribution
- **WHEN** a maintainer inspects the repository root and legal docs before release
- **THEN** Apache-2.0 license text is present and upstream notices are preserved

### Requirement: Fork MUST disclose modifications and non-affiliation
The fork MUST clearly state that it is a modified fork and MUST disclose non-affiliation/non-endorsement by upstream maintainers in user-facing documentation.

#### Scenario: README legal clarity
- **WHEN** a user reads the project README and release description
- **THEN** the project is clearly identified as an unofficial fork with modification disclosure

### Requirement: Fork MUST avoid implied trademark endorsement
The fork MUST NOT use upstream marks, logos, or product identity in a way that implies official endorsement, except nominative references required to identify origin.

#### Scenario: Branding review before publish
- **WHEN** maintainers review release assets and README visuals
- **THEN** no asset implies official upstream sponsorship or endorsement

### Requirement: Release process MUST include legal compliance checklist
Before publishing a release, maintainers MUST complete a checklist covering license inclusion, notices, modification disclosure, and non-affiliation statement.

#### Scenario: Pre-release compliance gate
- **WHEN** a release candidate is prepared
- **THEN** a documented compliance checklist is completed and stored in repo documentation
