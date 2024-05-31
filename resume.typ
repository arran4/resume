#import "@preview/modern-cv:0.3.1": *

#show: resume.with(
  author: (
      firstname: "Arran",
      lastname: "Ubels",
      email: "arran.ubels@gmail.com",
      phone: "(+61) 421-798-794",
      github: "arran4",
      linkedin: "arranubels",
      address: "Melbourne, Australia",
      positions: (
        "Software Developer",
        "Application & Integration Developer",
      )
  ),
  date: datetime.today().display()
)

= Experience

#resume-entry(
  title: "base2Services",
  location: "Melbourne, Australia",
  date: "2017 - 2024",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "IWT at base2Services",
  location: "Melbourne, Australia",
  date: "2023",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "CircleIn",
  location: "Melbourne, Australia",
  date: "2022",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "FosterNet at Foster Heating",
  location: "Melbourne, Australia",
  date: "2018- 2022",
  description: "Freelance Software Engineer"
)

#resume-entry(
  title: "Fulfilio via base2Services",
  location: "Melbourne, Australia",
  date: "2021",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "Myob",
  location: "Melbourne, Australia",
  date: "2021 - 2022",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "Redbubble via Cogent",
  location: "Melbourne, Australia",
  date: "2020",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "City Of Melbourne via Cogent",
  location: "Melbourne, Australia",
  date: "2019",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "Hooroo at Qantas via Cogent",
  location: "Melbourne, Australia",
  date: "2019",
  description: "Contract Software Engineer"
)

#resume-entry(
  title: "Foster Heating",
  location: "Melbourne, Australia",
  date: "2017-2018",
  description: "Freelance Software Engineer - XLM & VBA"
)

#resume-entry(
  title: "Consible",
  location: "Melbourne, Australia",
  date: "2016 - 2017",
  description: "Cofounder"
)

#resume-entry(
  title: "base2Services",
  location: "Melbourne, Australia",
  date: "2012 - 2015",
  description: "Application & Integration Developer"
)

#resume-item[
  - #lorem(20)
  - #lorem(15)
  - #lorem(25)
]

#resume-entry(
  title: "Ubels Computer Services",
  location: "Melbourne, Australia",
  date: "2009 - 2012",
  description: "Software Developer and System Admin"
)

#resume-entry(
  title: "Australian Sales and Promotions",
  location: "Melbourne, Australia",
  date: "2009 - 2012",
  description: "Contract C# and Microsoft Dynamics Developer"
)

#resume-entry(
  title: "Dimension Data (Now NTT)",
  location: "Melbourne, Australia",
  date: "2007 - 2009",
  description: "NAT MS Ops Center - CIS - Nortel IVR and Sun Solaris Engineer"
)

= Education

#resume-entry(
  title: "Monash University",
  location: "B.S. in Software Engineering",
  date: "2011-2013",
  description: "Part time"
)

#resume-entry(
  title: "Monash University",
  location: "B.S. in Computer Science",
  date: "2004 - 2007",
  description: "Full time"
)

= Projects

#resume-entry(
  title: "Golang Ical Parser & Serializer",
  location: [#github-link("arran4/golang-ical")],
  date: "May 2018 - Present",
  description: "Developer"
)

#resume-item[
  - Implement a bi-directional Ical parser and serializer in go - none which did both existed prior
  - Maintain, review & merge contributions
]

// = Skills
//
// #resume-skill-item("Languages", (strong("C++"), "Python", "Java", "C#", "JavaScript", "TypeScript"))
// #resume-skill-item("Tools", (strong("Excel"),))
