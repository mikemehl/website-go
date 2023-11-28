package data

type DiscographyEntry struct {
	Name        string
	ReleaseDate string
	Link        string
}

type MusicProject struct {
	Name        string
	Link        string
	StartDate   string
	EndDate     string
	Instruments []string
	Description string
	Brief       string
	Discography []DiscographyEntry
}
