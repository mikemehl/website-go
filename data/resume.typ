#let addresssection(address) = {
    if type(address) == "string" {
      [#emph(address)]
    } else {
      [ #emph(address.street) #emph( address.city ), #emph( address.state ) #emph( address.zip ) ]
    }
}

#let topsection(name, address, contact, objective) = {
  [
    = #name
    #addresssection(address) \
    #link("mailto:" + contact.email)[#contact.email] #sym.bar.v #link(contact.github) #sym.bar.v #link(contact.website)

    #objective

  ]
}

#let experience(exp) = {
  let (
    company: company,
    position: position,
    address: address,
    start_date: start, 
    end_date: end, 
    description: description, 
    brief: brief,
    highlights: highlights) = exp
  let website = if "website "in exp.keys() { exp.website } else { none }
  [
    === #company #sub(brief)
    #position #sym.bar.v #emph( start ) - #emph( end ) #sym.bar.v #addresssection(address) 
    #if website != none { [ #link(website)[#website] ] }  \
    #description \
    #for highlight in highlights {
      [- #highlight]
    }
  ]
}

#let experiencesection(experiences) = {
  [
    == Experience
    #for e in experiences {
        experience(e)
    }
  ]
}

#let education(edu) = {
  let (
    name: name,
    degrees: degrees,
    address: address,
    gpa: gpa) = edu
  [
    === #name
    #degrees.map(d => emph(d)).join([ #sym.bar.v ]) \
    #addresssection(address) \
    GPA: #gpa \
    #parbreak()\
  ]
}

#let educationsection(educations) = {
  let first = educations.at(0)
  let second = educations.at(1)
  [
    == Education
    #education(first)
    #education(second)
  ]
}

#let interestssection(interests) = {
  [
    == Interests
    #grid(
        columns: (1fr, 1fr), 
        rows: 1,
        [
          *Professional* 
          #for interest in interests.professional {
            [- #interest]
          }
        ],
        [
          *Personal* 
          #for interest in interests.personal {
            [- #interest]
          }
        ]
        )
      ]
}

#let skillssection(skills) = {
  [ 
    == Skills
    #grid(
    columns: (1fr, 1fr, 1fr), 
    rows: 1,
    [ 
    *Languages*
    #for category in skills.languages.keys() { 
      let skill_list = skills.languages.at(category)
      if category != "basic" {
        for skill in skill_list {
          [- #skill]
        }
      }
    } ],
    [ 
    *Platforms*
    #for skill in skills.platforms {
      [- #skill]
    } ],
    [ 
    *Tools*
    #for skill in skills.tools {
      [- #skill]
    } ])
  ]
}

#let data = yaml("resume.yaml")

#set par(
  justify: true,
)
#set text(
    font: ("Fira Sans"),
    lang: "en",
    size: 10pt,
    fallback: false
  )

#set page(
  paper: "a4",
  margin: (
    top: 0.3in,
    bottom: 0.3in,
    x: 0.4in
  )
)

#set list(
  tight: true,
  indent: 1em
)

#show link: underline

#show heading.where(level: 1): set text(size: 2em)

#topsection(data.name, data.address, data.contact, data.objective)
#line(length: 100%)
#experiencesection(data.experience) 
#line(length: 100%)
#grid(
  columns: (5fr, 1fr, 5fr),
  educationsection(data.education),
  line(length: 20%, angle: 90deg),
  skillssection(data.skills))
