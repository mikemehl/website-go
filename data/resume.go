package data

const (
	ProficiencyBasic = iota
	ProficinecyProficient
	ProficiencyExpert
)

type Proficiency int

type ResumeLanguageSkill struct {
	Name        string
	Proficiency Proficiency
}

type ResumeSkills struct {
	Languages []ResumeLanguageSkill
	Platforms []string
	Tools     []string
}

type ResumeExperience struct {
	Name        string
	Address     string
	Brief       string
	Website     string
	Description string
	Position    string
	StartDate   string
	EndDate     string
	Highlights  []string
}

type ResumeEducation struct {
	Address    string
	Degrees    []string
	StartDate  string
	EndDate    string
	Gpa        string
	Highlights []string
}

type ResumeContact struct {
	Email     string
	Github    string
	Phone     string
	Sourcehut string
	Website   string
}

type ResumeAbout struct {
	Name      string
	Objective string
	Address   string
	ResumeContact
}

type Resume struct {
	ResumeAbout
	Education  []ResumeEducation
	Experience []ResumeExperience
	Sills      ResumeSkills
}
