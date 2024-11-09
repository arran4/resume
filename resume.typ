#import "@preview/modern-cv:0.7.0": *

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
  date: "2017 - February 2024",
  description: "Contract Software Engineer"
)

#resume-item[
  - Develop in a wide range of languages, frameworks and environments.
  - Go, Python, ColdFusion, Java, Kotlin, Typescript, C\#, Ruby, Shell Scripting
  - AWS SAM, SvelteKit, Apache Camel, Karaf, Github Actions
  - Designed and built a AWS Resource auditor in the style of a linter
  - Built Jenkins Plugins relating to inventory and data warehousing (Data Lake.)
  - Built and maintained a pure multi-container Bash application for cloud integrated RDS backups
]

#resume-entry(
  title: "IWT",
  location: "Melbourne, Australia",
  date: "2023",
  description: "Contract Software Engineer via base2Services"
)

#resume-item[
  - Took over responsibility for converting designs to a fully fledged Typescript SvelteKit serverless application handed over before launch to the directors of the client
  - Aided, trained and reviewed changes of juniors
  - Sole senior on project, also responsible for the CI/CD system and deployment to AWS via AWS SAM & CDN, completely Serverless deploy
  - Maintained libraries and components as required, pushed upstream changes as required, built services to support JAM stack
]

#resume-entry(
  title: "CircleIn",
  location: "Melbourne, Australia",
  date: "2022",
  description: "Contract Software Engineer"
)

#resume-item[
  - Designed, built, maintained, documented and trained resources to use; a mail integration, processing and templating serverless application in Go
  - Worked with Python with AWS Athena, Data lake & Glue. Document pre-existing "click-ops" solution, fixing and resolving issues, fully Kotlin based CDK conversion.
]

#resume-entry(
  title: "FosterNet at Foster Heating",
  location: "Melbourne, Australia",
  date: "2018- 2022",
  description: "Freelance Software Engineer"
)

#resume-item[
  - Translated, quoted, designed, produced, supported a complete Excel to website conversion of their quoting application (From a set of network shared Excel 1997 XLM Macro document.)
  - Go on Google Apps Engine Classic, Typescript Vue.js front end, Github Actions for CI
]

#resume-entry(
  title: "Fulfilio",
  location: "Melbourne, Australia",
  date: "2021",
  description: "Contract Software Engineer via base2Services"
)

#resume-item[
  - Scoped, designed, built, and handed over a Apache Camel integration, using Oracle's GraalVM native compilation and AWS Fargate
  - Jenkins for CI, Docker for the container, worked with DevOps for deployment system.
]

#resume-entry(
  title: "Myob",
  location: "Melbourne, Australia",
  date: "2021 - 2022",
  description: "Contract Software Engineer"
)

#resume-item[
  - Educational role - No development - Teaching programming in Python + Django to assist with career change to DevOps.
  - Was responsible for assisting a ops team learn development practices, by helping them develop an application in Python to reduce their workload.
  - Taught CA cert checking, and OAuth2 low levels, also Go programming via feedback, pull request reviews, and producing educational content.
]

#resume-entry(
  title: "Redbubble",
  location: "Melbourne, Australia",
  date: "2020",
  description: "Contract Software Engineer via Cogent"
)

#resume-item[
  - Part of a new team created to assist the marketing team with data integration projects
  - Used AWS Lambda, AWS Event Bridge, Apache Airflow, and GCP Bigquery for (mostly) Google Analytics
  - Mostly developed in Typescript. Was some Typescript + React development.
]

#resume-entry(
  title: "City Of Melbourne",
  location: "Melbourne, Australia",
  date: "2019",
  description: "Contract Software Engineer via Cogent"
)

#resume-item[
  - Contract for the early stages of City of Melbourne “Whats On”. Consultation, design, estimate, and site scaffolding.
  - Vue.js with a Ruby on Rails + Postgres backend
]

#resume-entry(
  title: "Qantas/Jetstar (formally Hooroo)",
  location: "Melbourne, Australia",
  date: "2019",
  description: "Contract Software Engineer via Cogent"
)

#resume-item[
  - Short contract to assisted lead developer with day to day for a Typescript - RxJS - React based vertical slice "Jetstar Packages".
]

#resume-entry(
  title: "Foster Heating",
  location: "Melbourne, Australia",
  date: "2017-2018",
  description: "Freelance Software Engineer - XLM & VBA"
)

#resume-item[
  - Initial engagement, maintain the existing application with a couple of needed expansions as I learned the system for a future build out
  - Took client requirements, quoted, build, deployed and supported changes to an existing Excel XLM application (added some VBA for easier reading.)
]

#resume-entry(
  title: "Consible",
  location: "Melbourne, Australia",
  date: "2016 - 2017",
  description: "Cofounder"
)

#resume-item[
  - Went through an accelerator, sought customers, architecture, planning, finances, etc
  - 80% of the dev and ops work: built out a full suite of Micro services. Using, Go, React, etcd, redis, TiDB, Wrecker (CI), extensive use of Docker,
  - Built desktop apps, web apps, Android mobile app.
]

#resume-entry(
  title: "base2Services",
  location: "Melbourne, Australia",
  date: "2012 - 2015",
  description: "Application & Integration Developer"
)

#resume-item[
  - Design, develop and deploy solutions for clients both external and internal.
  - SCRUM Software life cycle.
  - Implement and maintain a Continuous Integration (CI) pipeline for existing and new projects, Jenkins and Octopus Deploy
  - Maintain, estimate and extend existing Jboss 4 and Jboss 7 Java applications
  - Extend existing applications with REST and SOAP based API for 3rd parties and mobile devices
  - Develop and maintain Open Source: Kagura Bi, a simple reporting service, built on Karaf, Camel, Spring, REST and JQuery.
  - Maintain, adapt and expand C\# 2.0 for Windows Mobile applications
  - Work with operations to design and develop applications to assist and automate, particularly relating to AWS and SaaS offerings
  - Worked on a couple internal startups / spin-outs in a range of languages, Go, Java, Python, C\#, ColdFusion, and tools, Apache Camel, Karaf, Jboss.
]

#resume-entry(
  title: "Ubels Computer Services",
  location: "Melbourne, Australia",
  date: "2009 - 2011",
  description: "Contract Software Developer and System Admin"
)

#resume-item[
  - Built Android Apps. Deployed and maintained ESXi Servers, running LAMP stack educational software (mostly Moodle/Mahara.)
  - Designed and documented deployments, and infrastructure at various small clients.
]

#resume-entry(
  title: "Australian Sales and Promotions",
  location: "Melbourne, Australia",
  date: "2009 - 2011",
  description: "Contract C\# and Microsoft Dynamics Developer"
)

#resume-item[
  - Designed, built and maintained internal applications in C\#, RCTI generator, Sales Monitoring & Reporting
  - Customized and extended Microsoft Dynamics with applications and plugins to meet requirements
  - Trained staff up in internal tools and Microsoft software, Dynamics, Reporting services, etc
]

#resume-entry(
  title: "Dimension Data (Now NTT)",
  location: "Melbourne, Australia",
  date: "2007 - 2009",
  description: "NAT MS Ops Center - CIS - Nortel IVR and Sun Solaris Engineer"
)

#resume-item[
  - Maintained Sun Servers (Solaris 8,9,10) and Nortel IVRs inside Telstra, Sensis, and some banks and mining companies
  - Built internal tools in PHP, and built up the KnowledgeBase (a wiki)
]

= Education

#resume-entry(
  title: "Monash University",
  location: "B.S. in Software Engineering",
  date: "2011-2013",
  description: "Clayton - Part time"
)

#resume-entry(
  title: "Monash University",
  location: "B.S. in Computer Science",
  date: "2004 - 2007",
  description: "Clayton - Full time"
)

= Projects

#resume-entry(
  title: "Golang iCal Parser & Serializer",
  location: [#github-link("arran4/golang-ical")],
  date: "May 2018 - Present",
  description: "BDFL"
)

#resume-item[
  - Implement a bi-directional iCal parser and serializer in go - none which did both existed prior
  - Maintain, review & merge contributions
]

= Preferences

I am comfortable with most languages, however that doesn't mean I don't have preferences.

#resume-skill-item("Languages", (strong("Go"), strong("Typescript"), "Dart", ))
#resume-skill-item("Frameworks", (strong("SvelteKit"), strong("Flutter"), "Vue", ))
#resume-skill-item("Tools", (strong("Github Actions"), "Gitlab", "Jenkins", "AWS SAM CLI", ))
#resume-skill-item("Infra", (strong("FaaS"), strong("Google App Engine"), "ECS / Fargate", "Containerization", ))

= Aspirations

I am interested in getting more involved with some technologies that I haven't used yet.

#resume-skill-item("Languages", (strong("Rust"), strong("Zig"), "WASM", ))
#resume-skill-item("Tools", (strong("Kubernetes"), ))
