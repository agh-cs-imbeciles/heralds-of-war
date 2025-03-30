%%
%% This is file `book-ps.cls', lmdps
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% classes.dtx  (with options: `book')
%%
%% This is a generated file.
%%
%% Copyright 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006
%% The LaTeX3 Project and any individual authors listed elsewhere
%% in this file.
%%
%% This file was generated from file(s) of the LaTeX base system.
%% --------------------------------------------------------------
%%
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%%
%% This file has the LPPL maintenance status "maintained".
%%
%% This file may only be distributed together with a copy of the LaTeX
%% base system. You may however distribute the LaTeX base system without
%% such generated files.
%%
%% The list of all files belonging to the LaTeX base distribution is
%% given in the file `manifest.txt'. See also `legal.txt' for additional
%% information.
%%
%% The list of derived (unpacked) files belonging to the distribution
%% and covered by LPPL is defined by the unpacking scripts (with
%% extension .ins) which are part of the distribution.
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{lmdEN}[2008/01/01 v1.0]

%========================================>
\DeclareOption{natbib}{\ExecuteOptions{oribibl}%
\AtEndOfClass{% Loading package 'NATBIB'
\RequirePackage{natbib}
% Changing some parameters of NATBIB
\setlength{\bibhang}{\parindent}
%\setlength{\bibsep}{0mm}
\let\bibfont=\small
\def\@biblabel#1{#1.}
\newcommand{\etal}{\textit{et al}.}
%\bibpunct[,]{(}{)}{;}{a}{}{,}}}
}}
% MMA environment
\let\if@spthms\iftrue
\DeclareOption{nospthms}{\let\if@spthms\iffalse}
%
\let\envankh\@empty   % no anchor for "theorems"
%
\let\if@envcntreset\iffalse % environment counter is not reset
\let\if@envcntresetsect=\iffalse % reset each section?
\DeclareOption{envcountresetchap}{\let\if@envcntreset\iftrue}
\DeclareOption{envcountresetsect}{\let\if@envcntreset\iftrue
\let\if@envcntresetsect=\iftrue}
%
\let\if@envcntsame\iffalse  % NOT all environments work like "Theorem",
                            % each using its own counter
\DeclareOption{envcountsame}{\let\if@envcntsame\iftrue}
%
\let\if@envcntshowhiercnt=\iffalse % do not show hierarchy counter at all
%
% enhance theorem counter
\DeclareOption{envcountchap}{\def\envankh{chapter}% show \thechapter along with theorem number
\let\if@envcntshowhiercnt=\iftrue}
%
\DeclareOption{envcountsect}{\def\envankh{section}% show \thesection along with theorem number
\let\if@envcntshowhiercnt=\iftrue
\ExecuteOptions{envcountresetsect}}
% reset environment counters every new contribution by default
\ExecuteOptions{envcountresetchap}


% languages
\let\switcht@@therlang\relax
\def\ds@deutsch{\def\switcht@@therlang{\switcht@deutsch}}
\def\ds@francais{\def\switcht@@therlang{\switcht@francais}}
%
\AtBeginDocument{\@ifpackageloaded{babel}{%
\@ifundefined{extrasenglish}{}{\addto\extrasenglish{\switcht@albion}}%
\@ifundefined{extrasfrenchb}{}{\addto\extrasfrenchb{\switcht@francais}}%
\@ifundefined{extrasgerman}{}{\addto\extrasgerman{\switcht@deutsch}}%
}{\switcht@@therlang}%
}
% style for vectors
\DeclareOption{vecphys}{\def\vec@style{phys}}
% running heads
\let\if@runhead\iftrue
\DeclareOption{norunningheads}{\let\if@runhead\iffalse}
% referee option
\let\if@referee\iffalse
\def\makereferee{\def\baselinestretch{2}\selectfont
\newbox\refereebox
\setbox\refereebox=\vbox to\z@{\vskip0.5cm%
  \hbox to\textwidth{\normalsize\tt\hrulefill\lower0.5ex
        \hbox{\kern5\p@ referee's copy\kern5\p@}\hrulefill}\vss}%
\def\@oddfoot{\copy\refereebox}\let\@evenfoot=\@oddfoot}
\DeclareOption{referee}{\let\if@referee\iftrue
\AtBeginDocument{\makereferee\small\normalsize}}
% modification of thebibliography
\let\if@openbib\iffalse
\DeclareOption{openbib}{\let\if@openbib\iftrue}
% LaTeX standard, sectionwise references
\DeclareOption{oribibl}{\let\oribibl=Y}
\DeclareOption{chaprefs}{\let\chpbibl=Y}
%
% size and style of headings
\newcommand{\partsize}{\Large}
\newcommand{\partstyle}{\bfseries\boldmath}
\newcommand{\chapsize}{\Large}
\newcommand{\chapstyle}{\bfseries\boldmath}
\newcommand{\secsize}{\large}
\newcommand{\secstyle}{\bfseries\boldmath}
\newcommand{\subsecsize}{\normalsize}
\newcommand{\subsecstyle}{\bfseries\boldmath}

\def\newendpage {\par
                 \ifdim \pagetotal>\topskip
                     \else\thispagestyle{empty}
                 \fi
                 \vfil\penalty -\@M}
\def\clearpage{%
  \ifvmode
    \ifnum \@dbltopnum =\m@ne
      \ifdim \pagetotal <\topskip
        \hbox{}
      \fi
    \fi
  \fi
  \newendpage
  \write\m@ne{}
  \vbox{}
  \penalty -\@Mi
}
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
    \hbox{}\newendpage\if@twocolumn\hbox{}\newpage\fi\fi\fi}

\newcommand{\clearemptydoublepage}{%
        \newpage{\pagestyle{empty}\cleardoublepage}}
\newcommand{\startnewpage}{\if@openright\clearemptydoublepage\else\clearpage\fi}

% MiniTOC
% one outputstream for all minitocs
\newwrite\minitoc
\newcounter{minitocdepth}
\setcounter{minitocdepth}{0}

% stolen from LaTeX.ltx - read miniTOC and redirect output stream
\long\def \protected@immwrite#1#2#3{%
      \begingroup
       \let\thepage\relax
       #2%
       \let\protect\@unexpandable@protect
       \edef\reserved@a{\immediate\write#1{#3}}%
       \reserved@a
      \endgroup
      \if@nobreak\ifvmode\nobreak\fi\fi}
%
\newcommand{\@mtstarttoc}[1]
{\begingroup
 \makeatletter
 \immediate\write\@auxout{\string\immediate\string\closeout\string\minitoc}%
 \typeout{input jobname.#1}%
 \@input{\jobname.#1}%
 \protected@immwrite\@auxout
   {\let\label\@gobble \let\index\@gobble
    \let\glossary\@gobble}%
   {\immediate\openout\minitoc \jobname.#1\relax}
 \global\@nobreakfalse\endgroup}
%
\newcommand{\@mtstarttocquiet}[1]
{\begingroup
 \makeatletter
 \protected@write\@auxout
   {\let\label\@gobble \let\index\@gobble
    \let\glossary\@gobble}%
   {\immediate\openout\minitoc \jobname.#1\relax}
 \global\@nobreakfalse\endgroup}
%
\newcommand{\mtaddtocont}[1]
{\protected@write \@auxout
  {\let\label\@gobble \let\index\@gobble
   \let\glossary\@gobble}%
  {\string\@mtwritefile{#1}}}
%
\newcommand{\@mtwritefile}[1]
{\@temptokena{#1} \immediate\write\minitoc{\the\@temptokena}}

\AtEndDocument{\immediate\write\@auxout{\string\immediate
\string\closeout\string\minitoc}}

\newcommand{\dominitoc}{\ifnum \c@minitocdepth<1
        \@mtstarttocquiet{t\thecontribution}\relax
    \else
        \@mtstarttoc{t\thecontribution}\par\addvspace\bigskipamount
    \fi}

%<==============================================================================

\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagetrue
\newif\if@openright
\newif\if@mainmatter \@mainmattertrue
\if@compatibility\else
\DeclareOption{a4paper}
   {\setlength\paperheight {297mm}%
    \setlength\paperwidth  {210mm}}
\DeclareOption{a5paper}
   {\setlength\paperheight {210mm}%
    \setlength\paperwidth  {148mm}}
\DeclareOption{b5paper}
   {\setlength\paperheight {250mm}%
    \setlength\paperwidth  {176mm}}
\DeclareOption{letterpaper}
   {\setlength\paperheight {11in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{legalpaper}
   {\setlength\paperheight {14in}%
    \setlength\paperwidth  {8.5in}}
\DeclareOption{executivepaper}
   {\setlength\paperheight {10.5in}%
    \setlength\paperwidth  {7.25in}}
\DeclareOption{landscape}
   {\setlength\@tempdima   {\paperheight}%
    \setlength\paperheight {\paperwidth}%
    \setlength\paperwidth  {\@tempdima}}
\fi
\if@compatibility
  \renewcommand\@ptsize{0}
\else
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\fi
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\if@compatibility\else
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\fi
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\if@compatibility\else
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\fi
\DeclareOption{titlepage}{\@titlepagetrue}
\if@compatibility\else
\DeclareOption{notitlepage}{\@titlepagefalse}
\fi
\if@compatibility
\@openrighttrue
\else
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\fi
\if@compatibility\else
\DeclareOption{onecolumn}{\@twocolumnfalse}
\fi
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}
\ExecuteOptions{letterpaper,10pt,twoside,onecolumn,final,openright}
\ProcessOptions
\input{bk1\@ptsize.clo}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
%===========================================================>
% various sizes and settings for contributed works

\setlength{\textwidth}{336pt}   %  11.8cm
%\setlength{\textheight}{12pt}\multiply\textheight by 45\relax
\setlength{\textheight}{565\p@}
\setlength{\topmargin}{0cm}
\setlength\oddsidemargin   {2cm}
\setlength\evensidemargin  {-2cm}
\setlength\marginparwidth{90\p@}
\setlength\headsep   {12\p@}

%<===========================================================

\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\if@twoside
  \def\ps@headings{%
      \let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\thepage\hfil\slshape\leftmark}%
      \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}}{}}%
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\z@
          \thesection. \ %
        \fi
        ##1}}}}
\else
  \def\ps@headings{%
    \let\@oddfoot\@empty
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter. \ %
          \fi
        \fi
        ##1}}}}
\fi
\def\ps@myheadings{%
%   \let\@oddfoot\@empty
    \let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil{\it\@runauthor}\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil{\it\@runtitle}{\hfil}\thepage}%
    \def\@oddfoot{{\oddpages}{\hfil}}%
    \def\@evenfoot{{\hfil}{\evenpages}}
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble
    }
%\def\ps@myheadings{%
%    \let\@oddfoot\@empty\let\@evenfoot\@empty
%    \def\@evenhead{\upshape \thepage\hfil{\it\@runauthor}\hfil\phantom{\thepage}}%
%    \def\@oddhead{\phantom{\thepage}\hfil{\it\@runtitle}\hfil \upshape\thepage}%
%    \let\@mkboth\@gobbletwo
%    \let\sectionmark\@gobble
%    \let\subsectionmark\@gobble
%    }

  \if@titlepage
  \newcommand\maketitle{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let \footnote \thanks
  \null\vfil
  \vskip 60\p@
  \begin{center}%
    {\LARGE \@title \par}%
    \vskip 3em%
    {\large  aaaa
     \lineskip .75em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
      \vskip 1.5em%
    {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \@thanks
  \vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\else
\newcommand\maketitle{\par
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne
        \@maketitle
      \else
        \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
    \thispagestyle{plain}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}
\fi
\newcommand*\chaptermark[1]{}
\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {chapter}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thechapter {\@arabic\c@chapter}
\renewcommand \thesection {\@arabic\c@section}
%\renewcommand \thesection {\c@section.\hskip-0.6em}
\renewcommand\thesubsection   {\thesection.\@arabic\c@subsection}
%\renewcommand\thesubsection   {\@arabic\c@section.\@arabic\c@subsection.\hskip-0.6em}
\renewcommand\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
%\renewcommand\thesubsubsection{\@arabic\c@section.\@arabic\c@subsection.\@arabic\c@subsubsection.\hskip-0.6em}
\renewcommand\theparagraph    {\thesubsubsection\@arabic\c@paragraph.}
\renewcommand\thesubparagraph {\theparagraph\@arabic\c@subparagraph.}
\newcommand\@chapapp{\chaptername}
\newcommand\frontmatter{%
    \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}}
\newcommand\mainmatter{%
    \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}}
\newcommand\backmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse}
\newcommand\part{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \thispagestyle{plain}%
  \if@twocolumn
    \onecolumn
    \@tempswatrue
  \else
    \@tempswafalse
  \fi
  \null\vfil
  \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       \huge\bfseries \partname\nobreakspace\thepart
       \par
       \vskip 20\p@
     \fi
     \Huge \bfseries #2\par}%
    \@endpart}
\def\@spart#1{%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \Huge \bfseries #1\par}%
    \@endpart}
\def\@endpart{\vfil\newpage
              \if@twoside
               \if@openright
                \null
                \thispagestyle{empty}%
                \newpage
               \fi
              \fi
              \if@tempswa
                \twocolumn
              \fi}
\newcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                       \if@mainmatter
                         \refstepcounter{chapter}%
                         \typeout{\@chapapp\space\thechapter.}%
                         \addcontentsline{toc}{chapter}%
                                   {\protect\numberline{\thechapter}#1}%
                       \else
                         \addcontentsline{toc}{chapter}{#1}%
                       \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}
\def\@makechapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        \huge\bfseries \@chapapp\space \thechapter
        \par\nobreak
        \vskip 20\p@
      \fi
    \fi
    \interlinepenalty\@M
    \Huge \bfseries #1\par\nobreak
    \vskip 40\p@
  }}
\def\@schapter#1{\if@twocolumn
                   \@topnewpage[\@makeschapterhead{#1}]%
                 \else
                   \@makeschapterhead{#1}%
                   \@afterheading
                 \fi}
\def\@makeschapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \Huge \bfseries  #1\par\nobreak
    \vskip 40\p@
  }}
\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\large\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
        \setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
\if@compatibility
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi
\newcommand\appendix{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\@addtoreset {equation}{chapter}
\renewcommand\theequation
  {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@equation}
\newcounter{figure}[chapter]
\renewcommand \thefigure
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}[chapter]
\renewcommand \thetable
     {\ifnum \c@chapter>\z@ \thechapter.\fi \@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{2}
\newcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    }
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi}
\newcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
\newcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\z@
    \addpenalty\@secpenalty
    \addvspace{1.0em \@plus\p@}%
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss }\par
    \endgroup
  \fi}
\newcommand*\l@subsection{\@dottedtocline{2}{0.0em}{0.0em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{7.0em}{4.1em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{10em}{5em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{12em}{6em}}
%===================================================>

%<====================================================
\newcommand\listoffigures{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
     {\chapter*{\bibname}%
      \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \twocolumn[\section*{\large{\indexname}{\indexv}}{\indexn}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\@addtoreset{footnote}{chapter}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\bibname{References}
\newcommand\abstractname{Abstract.}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\chaptername{Chapter}
\newcommand\appendixname{Appendix}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{headings}
\pagenumbering{arabic}
\if@twoside
\else
  \raggedbottom
\fi
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi

\newenvironment{abstract}{%
      \advance\topsep by-0.25cm\relax\small
      \labelwidth=\z@
      \listparindent=\z@
      \itemindent\listparindent
      \trivlist\item[\hskip\labelsep\bfseries{\normalsize{\abstractname\santr}}]%
      \if!\abstractname!\hskip-\labelsep\fi
    }
    {\endtrivlist}

\def\keywords#1{\if@keywords\vskip1pt\else\vskip1pt\@keywordstrue\fi {\parindent=0pt\begin{minipage}[t]{\textwidth}{\footnotesize {\bfseries \KeyW:\,\,}{#1}}\end{minipage}\CR}\vskip20pt}
\def\ams#1{\if@ams\vskip1pt\else\vskip1pt\@amstrue\fi {\vspace{-6mm}\parindent=0pt\begin{minipage}[t]{\textwidth}{\footnotesize {\bfseries AMS Subject Classification:\ } {#1}}\end{minipage}}\vskip20pt}

\gdef\thecatchlines{%
\begin{minipage}[b]{0.91\linewidth}
\vbox to48pt{
    \vss  \raggedright{\null{\small{\LMDp}} }
    \vskip .5em
    \leftline{\null{\small {\LMDpr}} }
}
 \end{minipage}
 \begin{minipage}[t]{0.08\linewidth}
\includegraphics[width=\linewidth]{agh.eps}\newline
\end{minipage}
}
%
%\gdef\thecatchlines{%
%\vbox to1pt{\vss \leftline{\null{\small{\LMDp}}\hfill{,}}
% \leftline{\null{\small {\LMDpr}}\hfill{\footnotesize {\LMDpv}}}
%  \leftline{\null{\footnotesize{\LMDdoi}}\hfill{\footnotesize{\LMDpp}}}
%\leftline{\null{\footnotesize }}
% \leftline{\null{\footnotesize {\LMDppp}}}
%}
%\vbox to1pt{\vss \leftline{\null{\small{\LMDp}}\hfill{\includegraphics[width=0.25\linewidth]{LMR.eps}}}
% \leftline{\null{\small {\LMDpr}}\hfill{\footnotesize {\LMDpv}}}
%  \leftline{\null{\footnotesize{\LMDdoi}}\hfill{\footnotesize{\LMDpp}}}
%\leftline{\null{\footnotesize }}
% \leftline{\null{\footnotesize {\LMDppp}}}
%}


%}%

\def\runauthor#1{\gdef\@runauthor{#1}} \let\@runauthor\relax
\def\runtitle#1{\gdef\@runtitle{#1}}   \let\@runtitle\relax
\let\maketitle\relax
\def\topmatter{%
 \begingroup
\def\footnote##1##{\thanks}
   \def\@makefnmark{\hbox{$\m@th^{\@thefnmark}$}}%
     \global\@topnum\z@\newpage\raggedright\thecatchlines}
%
\def\endtopmatter{\thispagestyle{empty}\@thanks
 \endgroup
 \let\maketitle\relax
 \let\@maketitle\relax
 \gdef\@thanks{}\gdef\@author{}\gdef\@title{}\let\thanks\relax
 \vskip18pt}
%
\def\nohyphen{\pretolerance=10000 \tolerance=10000
\hyphenpenalty=10000 \exhyphenpenalty=10000}
%
\newif\if@address \@addressfalse
\newif\if@institution \@institutionfalse
\newif\if@email \@emailfalse
\newif\if@reci \@recifalse
\newif\if@recii \@reciifalse
\newif\if@keywords \@keywordsfalse
\newif\if@ams \@amsfalse
\def\sep{\unskip, }\def\and{\unskip~i }
\let\@ldthanks\thanks
\def\elem@nothanks#1\thanks{\futurelet\@peektok\elem@thanks}
\def\elem@thanks{\ifx\@peektok\relax\else \expandafter\elem@morethanks\fi}
%
\def\elem@morethanks#1{\@ldthanks{#1}\elem@nothanks}
%
\def\title#1{\vskip28pt\vbox{\let\thanks\@gobble\nohyphen\raggedright%
\Large\bfseries{#1}\expandafter\elem@nothanks#1\thanks\relax}\vskip12pt}
\def\author#1{{\let\thanks\@gobble\large{\bfseries{\expandafter{#1}}}%
\expandafter\elem@nothanks#1\thanks\relax}}
\def\institution#1{\if@institution\vskip1pt\else\vskip1pt\@institutiontrue\fi\vbox{\small\it #1}}
\def\address#1{\if@address\vskip1pt\else\vskip1pt\@addresstrue\fi\vbox{\small\rm #1}}
\def\noaddress#1{\vspace{#1}}
%\def\email#1{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi \mbox{E-mail:\ }\vbox{\tt #1}}
\def\email#1{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi \mbox{\small\ \,E-mail:\ }\vbox{\textcolor{MyBlue}{\small\href{mailto:#1}{\textcolor{MyBlue}{\tt{#1}}}}}}
\def\emaill#1#2{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi \mbox{\small\hspace{#2} \,E-mail:\ }\vbox{\small\href{mailto:#1}{\tt{#1}}}}
\def\Email#1{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi \mbox{\small\ \,E-mail(\emph{corresp}.):\ }\vbox{\small\href{mailto:#1}{\tt{#1}}}}
\def\reci#1{\scriptsize{\if@reci\vskip2pt\else\vskip12pt\@recitrue\fi\mbox{Received\ }\vbox{\rm #1; published \online}}}
\def\recii#1#2{\scriptsize{\if@recii\vskip2pt\else\vskip12pt\@reciitrue\fi\mbox{\rm Received\ #1;\ revised\ #2; published online \online}}}

\newcommand{\D}{\,d}
\newcommand{\E}{e}
\let\eul=\E
\newcommand{\I}{i}
\let\imag=\I
%
\providecommand{\bm}[1]{\mbox{\boldmath$#1$}}
\providecommand{\bmf}[1]{\mathbf{\emph{#1}}}
\def\cal{\mathcal}
\def\sym{\mathbb}
\def\scr{\mathscr}
%text
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
% MMA likes them as italics to depict variables
\DeclareMathSymbol{\Gamma}{\mathalpha}{letters}{"00}
\DeclareMathSymbol{\Delta}{\mathalpha}{letters}{"01}
\DeclareMathSymbol{\Theta}{\mathalpha}{letters}{"02}
\DeclareMathSymbol{\Lambda}{\mathalpha}{letters}{"03}
\DeclareMathSymbol{\Xi}{\mathalpha}{letters}{"04}
\DeclareMathSymbol{\Pi}{\mathalpha}{letters}{"05}
\DeclareMathSymbol{\Sigma}{\mathalpha}{letters}{"06}
\DeclareMathSymbol{\Upsilon}{\mathalpha}{letters}{"07}
\DeclareMathSymbol{\Phi}{\mathalpha}{letters}{"08}
\DeclareMathSymbol{\Psi}{\mathalpha}{letters}{"09}
\DeclareMathSymbol{\Omega}{\mathalpha}{letters}{"0A}
% the upright forms are defined here as \var<Character>
\DeclareMathSymbol{\varGamma}{\mathalpha}{operators}{"00}
\DeclareMathSymbol{\varDelta}{\mathalpha}{operators}{"01}
\DeclareMathSymbol{\varTheta}{\mathalpha}{operators}{"02}
\DeclareMathSymbol{\varLambda}{\mathalpha}{operators}{"03}
\DeclareMathSymbol{\varXi}{\mathalpha}{operators}{"04}
\DeclareMathSymbol{\varPi}{\mathalpha}{operators}{"05}
\DeclareMathSymbol{\varSigma}{\mathalpha}{operators}{"06}
\DeclareMathSymbol{\varUpsilon}{\mathalpha}{operators}{"07}
\DeclareMathSymbol{\varPhi}{\mathalpha}{operators}{"08}
\DeclareMathSymbol{\varPsi}{\mathalpha}{operators}{"09}
\DeclareMathSymbol{\varOmega}{\mathalpha}{operators}{"0A}
% Upright Lower Case Greek letters without using a new MathAlphabet
\newcommand{\greeksym}[1]{\usefont{U}{psy}{m}{n}#1}
\newcommand{\greeksymbold}[1]{{\usefont{U}{psy}{b}{n}#1}}
\newcommand{\allmodesymb}[2]{\relax\ifmmode{\mathchoice
{\mbox{\fontsize{\tf@size}{\tf@size}#1{#2}}} {\mbox{\fontsize{\tf@size}{\tf@size}#1{#2}}}
{\mbox{\fontsize{\sf@size}{\sf@size}#1{#2}}}
{\mbox{\fontsize{\ssf@size}{\ssf@size}#1{#2}}}} \else \mbox{#1{#2}}\fi}
% Definition of lower case Greek letters
\newcommand{\ualpha}{\allmodesymb{\greeksym}{a}}
\newcommand{\ubeta}{\allmodesymb{\greeksym}{b}}
\newcommand{\uchi}{\allmodesymb{\greeksym}{c}}
\newcommand{\udelta}{\allmodesymb{\greeksym}{d}}
\newcommand{\ugamma}{\allmodesymb{\greeksym}{g}}
\newcommand{\umu}{\allmodesymb{\greeksym}{m}}
\newcommand{\unu}{\allmodesymb{\greeksym}{n}}
\newcommand{\upi}{\allmodesymb{\greeksym}{p}}
\newcommand{\utau}{\allmodesymb{\greeksym}{t}}



\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width 50\p@
  \kern2.6\p@}

\newdimen\foot@parindent
\foot@parindent 10.83\p@

\long\def\@makefntext#1{\@setpar{\@@par\@tempdima \hsize
         \advance\@tempdima-\foot@parindent\parshape\@ne\foot@parindent
         \@tempdima}\par
         \parindent \foot@parindent\noindent \hbox to \z@{%
         \hss\hss$^{\@thefnmark}$ }#1}
% teoremu stylius ------------------------------------------------------------
\if@spthms
% Definition of the "\spnewtheorem" command.
%
% Usage:
%
%     \spnewtheorem{env_nam}{caption}[within]{cap_font}{body_font}
% or  \spnewtheorem{env_nam}[numbered_like]{caption}{cap_font}{body_font}
% or  \spnewtheorem*{env_nam}{caption}{cap_font}{body_font}
%
% New is "cap_font" and "body_font". It stands for
% fontdefinition of the caption and the text itself.
%
% "\spnewtheorem*" gives a theorem without number.
%
% A defined spnewthoerem environment is used as described
% by Lamport.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\@thmcountersep{.}
\def\@thmcounterend{.}
\newcommand\nocaption{\noexpand\@gobble}
\newdimen\spthmsep \spthmsep=3pt

\def\spnewtheorem{\@ifstar{\@sthm}{\@Sthm}}

% definition of \spnewtheorem with number

\def\@spnthm#1#2{%
  \@ifnextchar[{\@spxnthm{#1}{#2}}{\@spynthm{#1}{#2}}}
\def\@Sthm#1{\@ifnextchar[{\@spothm{#1}}{\@spnthm{#1}}}

\def\@spxnthm#1#2[#3]#4#5{\expandafter\@ifdefinable\csname #1\endcsname
   {\@definecounter{#1}\@addtoreset{#1}{#3}%
   \expandafter\xdef\csname the#1\endcsname{\expandafter\noexpand
     \csname the#3\endcsname \noexpand\@thmcountersep \@thmcounter{#1}}%
   \expandafter\xdef\csname #1name\endcsname{#2}%
   \global\@namedef{#1}{\@spthm{#1}{\csname #1name\endcsname}{#4}{#5}}%
                              \global\@namedef{end#1}{\@endtheorem}}}

\def\@spynthm#1#2#3#4{\expandafter\@ifdefinable\csname #1\endcsname
   {\@definecounter{#1}%
   \expandafter\xdef\csname the#1\endcsname{\@thmcounter{#1}}%
   \expandafter\xdef\csname #1name\endcsname{#2}%
   \global\@namedef{#1}{\@spthm{#1}{\csname #1name\endcsname}{#3}{#4}}%
                               \global\@namedef{end#1}{\@endtheorem}}}

\def\@spothm#1[#2]#3#4#5{%
  \@ifundefined{c@#2}{\@latexerr{No theorem environment `#2' defined}\@eha}%
  {\expandafter\@ifdefinable\csname #1\endcsname
  {\global\@namedef{the#1}{\@nameuse{the#2 }}%
  \expandafter\xdef\csname #1name\endcsname{#3}%
  \global\@namedef{#1}{\@spthm{#2}{\csname #1name\endcsname}{#4}{#5}}%
  \global\@namedef{end#1}{\@endtheorem}}}}

\def\@spthm#1#2#3#4{\topsep 7\p@ \@plus2\p@ \@minus4\p@
\labelsep=\spthmsep\refstepcounter{#1}%
\@ifnextchar[{\@spythm{#1}{#2}{#3}{#4}}{\@spxthm{#1}{#2}{#3}{#4}}}

\def\@spxthm#1#2#3#4{\@spbegintheorem{#2}{\csname the#1\endcsname}{#3}{#4}%
                    \ignorespaces}

\def\@spythm#1#2#3#4[#5]{\@spopargbegintheorem{#2}{\csname
       the#1\endcsname}{#5}{#3}{#4}\ignorespaces}

\def\normalthmheadings{\def\@spbegintheorem##1##2##3##4{\trivlist
                 \item[\hskip\labelsep{##3##1\ ##2\@thmcounterend}]##4}
\def\@spopargbegintheorem##1##2##3##4##5{\trivlist
      \item[\hskip\labelsep{##4##1\ ##2}]{##4\textup{[##3]}\@thmcounterend\ }##5}}
\normalthmheadings

\def\reversethmheadings{\def\@spbegintheorem##1##2##3##4{\trivlist
                 \item[\hskip\labelsep{##3##2\ ##1\@thmcounterend}]##4}
\def\@spopargbegintheorem##1##2##3##4##5{\trivlist
      \item[\hskip\labelsep{##4##2\ ##1}]{##4\textup{[##3]}\@thmcounterend\ }##5}}

% definition of \spnewtheorem* without number

\def\@sthm#1#2{\@Ynthm{#1}{#2}}

\def\@Ynthm#1#2#3#4{\expandafter\@ifdefinable\csname #1\endcsname
   {\global\@namedef{#1}{\@Thm{\csname #1name\endcsname}{#3}{#4}}%
    \expandafter\xdef\csname #1name\endcsname{#2}%
    \global\@namedef{end#1}{\@endtheorem}}}

\def\@Thm#1#2#3{\topsep 7\p@ \@plus2\p@ \@minus4\p@
\@ifnextchar[{\@Ythm{#1}{#2}{#3}}{\@Xthm{#1}{#2}{#3}}}

\def\@Xthm#1#2#3{\@Begintheorem{#1}{#2}{#3}\ignorespaces}

\def\@Ythm#1#2#3[#4]{\@Opargbegintheorem{#1}
       {#4}{#2}{#3}\ignorespaces}

\def\@Begintheorem#1#2#3{#3\trivlist
                           \item[\hskip\labelsep{#2#1\@thmcounterend}]}

\def\@Opargbegintheorem#1#2#3#4{#4\trivlist
      \item[\hskip\labelsep{#3#1}]{#3\textup{[#2]}\@thmcounterend\ }}

% initialize theorem environment

\if@envcntshowhiercnt % show hierarchy counter
   \def\@thmcountersep{.}
   \spnewtheorem{theorem}{Theorem}[\envankh]{\bfseries}{\itshape}
   \@addtoreset{theorem}{chapter}
\else          % theorem counter only
   \spnewtheorem{theorem}{Theorem}{\bfseries}{\itshape}
   \if@envcntreset
      \@addtoreset{theorem}{chapter}
      \if@envcntresetsect
         \@addtoreset{theorem}{section}
      \fi
   \fi
\fi

%definition of divers theorem environments
\spnewtheorem*{criterion*}{Criterion}{\bfseries}{\itshape}
\spnewtheorem*{algorithm*}{Algorithm}{\itshape}{\rmfamily}
\spnewtheorem*{claim*}{Claim}{\itshape}{\rmfamily}
%
\spnewtheorem*{case*}{Case}{\itshape}{\rmfamily}
\spnewtheorem*{conjecture*}{Conjecture}{\itshape}{\rmfamily}
\spnewtheorem*{corollary*}{Corollary}{\bfseries}{\itshape}
\spnewtheorem*{definition*}{Definition}{\bfseries}{\itshape}
\spnewtheorem*{example*}{Example}{\itshape}{\rmfamily}
\spnewtheorem*{exercise*}{Exercise}{\bfseries}{\rmfamily}
\spnewtheorem*{lemma*}{Lemma}{\bfseries}{\itshape}
\spnewtheorem*{note*}{Note}{\itshape}{\rmfamily}
\spnewtheorem*{problem*}{Problem}{\bfseries}{\rmfamily}
\spnewtheorem*{property*}{Property}{\itshape}{\rmfamily}
\spnewtheorem*{proposition*}{Proposition}{\bfseries}{\itshape}
\spnewtheorem*{question*}{Question}{\itshape}{\rmfamily}
\spnewtheorem*{solution*}{Solution}{\bfseries}{\rmfamily}
\spnewtheorem*{remark*}{Remark}{\itshape}{\rmfamily}


\newcommand\qedsymbol{\hbox{\rlap{$\sqcap$}$\sqcup$}}
\newcommand\qed{\relax\ifmmode\else\unskip\quad\fi\qedsymbol}
\newcommand\smartqed{\renewcommand\qed{\relax\ifmmode\qedsymbol\else
  {\unskip\nobreak\hfil\penalty50\hskip1em\null\nobreak\hfil\qedsymbol
  \parfillskip=\z@\finalhyphendemerits=0\endgraf}\fi}}


\spnewtheorem*{proof}{Proof}{\itshape}{\rmfamily}
\newenvironment{pf}%
  {\par\addvspace{12pt plus1pt minus3pt}\noindent
   {\it\proofname.}\kern 1em\ignorespaces}%
  {\par\addvspace{12pt plus1pt minus3pt}}
%
\@namedef{endpf}{\qed\par\addvspace{12pt plus1pt minus3pt}}
\@namedef{pf*}#1{\par\begingroup\def\proofname{#1}\pf\endgroup\ignorespaces}
\@namedef{endpf*}{\qed\par\addvspace{12pt plus1pt minus3pt}}
%

%
\if@envcntsame % all environments like "Theorem" - using its counter
   \def\spn@wtheorem#1#2#3#4{\@spothm{#1}[theorem]{#2}{#3}{#4}}
\else % all environments with their own counter
   \if@envcntshowhiercnt % show hierarchy counter
      \def\spn@wtheorem#1#2#3#4{\@spxnthm{#1}{#2}[\envankh]{#3}{#4}}
   \else          % environment counter only
      \if@envcntreset % environment counter is reset each section
         \if@envcntresetsect
            \def\spn@wtheorem#1#2#3#4{\@spynthm{#1}{#2}{#3}{#4}
             \@addtoreset{#1}{chapter}\@addtoreset{#1}{section}}
         \else
            \def\spn@wtheorem#1#2#3#4{\@spynthm{#1}{#2}{#3}{#4}
                                      \@addtoreset{#1}{chapter}}
         \fi
      \else
         \let\spn@wtheorem=\@spynthm
      \fi
   \fi
\fi
%
\let\spdefaulttheorem=\spn@wtheorem
%
\spn@wtheorem{criterion}{Criterion}{\bfseries}{\itshape}
\spn@wtheorem{algorithm}{Algorithm}{\itshape}{\rmfamily}
\spn@wtheorem{claim}{Claim}{\itshape}{\rmfamily}
%
\spn@wtheorem{case}{Case}{\itshape}{\rmfamily}
\spn@wtheorem{conjecture}{Conjecture}{\itshape}{\rmfamily}
\spn@wtheorem{corollary}{Corollary}{\bfseries}{\itshape}
\spn@wtheorem{definition}{Definition}{\bfseries}{\rmfamily}
\spn@wtheorem{example}{Example}{\itshape}{\rmfamily}
\spn@wtheorem{exercise}{Exercise}{\bfseries}{\rmfamily}
\spn@wtheorem{lemma}{Lemma}{\bfseries}{\itshape}
\spn@wtheorem{note}{Note}{\itshape}{\rmfamily}
\spn@wtheorem{problem}{Problem}{\itshape}{\rmfamily}
\spn@wtheorem{property}{Property}{\itshape}{\rmfamily}
\spn@wtheorem{proposition}{Proposition}{\bfseries}{\itshape}
\spn@wtheorem{question}{Question}{\itshape}{\rmfamily}
\spn@wtheorem{solution}{Solution}{\bfseries}{\rmfamily}
\spn@wtheorem{remark}{Remark}{\itshape}{\rmfamily}
%
% This is texte.tex
% it defines various texts and their translations
% called up with documentstyle options
\def\switcht@albion{%
\def\abbrsymbname{List of Abbreviations and Symbols}
\def\abstractname{Abstract.}%{Summary.}
\def\ackname{Acknowledgement.}
\def\andname{and}
\def\bibname{References}
\def\lastandname{, and}
\def\appendixname{Appendix}
\def\chaptername{Chapter}
\def\claimname{Claim}
\def\conjecturename{Conjecture}
\def\contentsname{Contents}
\def\corollaryname{Corollary}
\def\definitionname{Definition}
\def\examplename{Example}
\def\exercisename{Exercise}
\def\figurename{Fig.}
\def\keywordname{{\bf Key words:}}
\def\indexname{Index}
\def\lemmaname{Lemma}
\def\contriblistname{List of Contributors}
\def\listfigurename{List of Figures}
\def\listtablename{List of Tables}
\def\mailname{{\it Correspondence to\/}:}
\def\noteaddname{Note added in proof}
\def\notename{Note}
\def\partname{Part}
\def\prefacename{Preface}
\def\problemname{Problem}
\def\proofname{Proof}
\def\propertyname{Property}
\def\propositionname{Proposition}
\def\questionname{Question}
\def\refname{References}
\def\remarkname{Remark}
\def\seename{see}
\def\solutionname{Solution}
\def\subclassname{{\it Subject Classifications\/}:}
\def\tablename{Table}
\def\theoremname{Theorem}}
\switcht@albion
% Names of theorem like environments are already defined
% but must be translated if another language is chosen
%
\newenvironment{theopargself}
    {\def\@spopargbegintheorem##1##2##3##4##5{\trivlist
         \item[\hskip\labelsep{##4##1\ ##2}]{##4##3\@thmcounterend\ }##5}
     \def\@Opargbegintheorem##1##2##3##4{##4\trivlist
         \item[\hskip\labelsep{##3##1}]{##3##2\@thmcounterend\ }}}{}
\newenvironment{theopargself*}
    {\def\@spopargbegintheorem##1##2##3##4##5{\trivlist
         \item[\hskip\labelsep{##4##1\ ##2}]{\hspace*{-\labelsep}##4##3\@thmcounterend}##5}
     \def\@Opargbegintheorem##1##2##3##4{##4\trivlist
         \item[\hskip\labelsep{##3##1}]{\hspace*{-\labelsep}##3##2\@thmcounterend}}}{}
\fi

\def\@takefromreset#1#2{%
    \def\@tempa{#1}%
    \let\@tempd\@elt
    \def\@elt##1{%
        \def\@tempb{##1}%
        \ifx\@tempa\@tempb\else
            \@addtoreset{##1}{#2}%
        \fi}%
    \expandafter\expandafter\let\expandafter\@tempc\csname cl@#2\endcsname
    \expandafter\def\csname cl@#2\endcsname{}%
    \@tempc
    \let\@elt\@tempd}

%--Figuros  ir lenteles --------------------------------------------------------------------------
% redefininition of the captions for "figure" and "table" environments
%
\@ifundefined{floatlegendstyle}{\def\floatlegendstyle{\bfseries}}{}
\def\floatcounterend{.\ }
\def\capstrut{\vrule\@width\z@\@height\topskip}
\@ifundefined{captionstyle}{\def\captionstyle{\normalfont\small}}{}
\@ifundefined{instindent}{\newdimen\instindent}{}

\long\def\@caption#1[#2]#3{\par\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore\if@minipage\@setminipage\fi
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}

\def\twocaptionwidth#1#2{\def\first@capwidth{#1}\def\second@capwidth{#2}}
% Default: .46\textwidth
\twocaptionwidth{.46\textwidth}{.46\textwidth}

\def\leftcaption{\refstepcounter\@captype\@dblarg%
            {\@leftcaption\@captype}}

\def\rightcaption{\refstepcounter\@captype\@dblarg%
            {\@rightcaption\@captype}}

\long\def\@leftcaption#1[#2]#3{\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore
    \vskip\figcapgap
    \@maketwocaptions{\csname fnum@#1\endcsname}{\ignorespaces #3}%
    {\first@capwidth}\ignorespaces\hspace{.073\textwidth}\hfill%
  \endgroup}

\long\def\@rightcaption#1[#2]#3{\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore
    \@maketwocaptions{\csname fnum@#1\endcsname}{\ignorespaces #3}%
    {\second@capwidth}\par
  \endgroup}

\long\def\@maketwocaptions#1#2#3{%
   \parbox[t]{#3}{{\floatlegendstyle #1\floatcounterend}#2}}

\def\fig@pos{l}
\newcommand{\leftfigure}[2][\fig@pos]{\makebox[.4635\textwidth][#1]{#2}}
\let\rightfigure\leftfigure

\newdimen\figgap\figgap=0.5cm  % hgap between figure and sidecaption
%
\long\def\@makesidecaption#1#2{%
   \setbox0=\vbox{\hsize=\@tempdima
                  \captionstyle{\floatlegendstyle
                                         #1\floatcounterend}#2}%
   \ifdim\instindent<\z@
      \ifdim\ht0>-\instindent
         \advance\instindent by\ht0
         \typeout{^^JClass-Warning: Legend of \string\sidecaption\space for
                     \@captype\space\csname the\@captype\endcsname
                  ^^Jis \the\instindent\space taller than the corresponding float -
                  ^^Jyou'd better switch the environment. }%
         \instindent\z@
      \fi
   \else
      \ifdim\ht0<\instindent
         \advance\instindent by-\ht0
         \advance\instindent by-\dp0\relax
         \advance\instindent by\topskip
         \advance\instindent by-11\p@
      \else
         \advance\instindent by-\ht0
         \instindent=-\instindent
         \typeout{^^JClass-Warning: Legend of \string\sidecaption\space for
                     \@captype\space\csname the\@captype\endcsname
                  ^^Jis \the\instindent\space taller than the corresponding float -
                  ^^Jyou'd better switch the environment. }%
         \instindent\z@
      \fi
   \fi
   \parbox[b]{\@tempdima}{\captionstyle{\floatlegendstyle
                                        #1\floatcounterend}#2%
                          \ifdim\instindent>\z@ \\
                               \vrule\@width\z@\@height\instindent
                                     \@depth\z@
                          \fi}}
\def\sidecaption{\@ifnextchar[\sidec@ption{\sidec@ption[b]}}
\def\sidec@ption[#1]#2\caption{%
\setbox\@tempboxa=\hbox{\ignorespaces#2\unskip}%
\if@twocolumn
 \ifdim\hsize<\textwidth\else
   \ifdim\wd\@tempboxa<\columnwidth
      \typeout{Double column float fits into single column -
            ^^Jyou'd better switch the environment. }%
   \fi
 \fi
\fi
  \instindent=\ht\@tempboxa
  \advance\instindent by\dp\@tempboxa
\if t#1
\else
  \instindent=-\instindent
\fi
\@tempdima=\hsize
\advance\@tempdima by-\figgap
\advance\@tempdima by-\wd\@tempboxa
\ifdim\@tempdima<3cm
   \ClassWarning{SVMono}{\string\sidecaption: No sufficient room for the legend;
             ^^Jusing normal \string\caption}%
   \unhbox\@tempboxa
   \let\@capcommand=\@caption
\else
   \ifdim\@tempdima<4.5cm
      \ClassWarning{SVMono}{\string\sidecaption: Room for the legend very narrow;
               ^^Jusing \string\raggedright}%
      \toks@\expandafter{\captionstyle\sloppy
                         \rightskip=\z@\@plus6mm\relax}%
      \def\captionstyle{\the\toks@}%
   \fi
   \let\@capcommand=\@sidecaption
   \leavevmode
   \unhbox\@tempboxa
   \hfill
\fi
\refstepcounter\@captype
\@dblarg{\@capcommand\@captype}}
\long\def\@sidecaption#1[#2]#3{\addcontentsline{\csname
  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  the#1\endcsname}{\ignorespaces #2}}\begingroup
    \@parboxrestore
    \@makesidecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\fig@type{figure}

\def\leftlegendglue{\hfil}
\newdimen\figcapgap\figcapgap=5\p@   % vgap between figure and caption
\newdimen\tabcapgap\tabcapgap=5.5\p@ % vgap between caption and table

\long\def\@makecaption#1#2{%
 \captionstyle
 \ifx\@captype\fig@type
   \vskip\figcapgap
 \fi
 \setbox\@tempboxa\hbox{{\floatlegendstyle #1\floatcounterend}%
 \capstrut #2}%
 \ifdim \wd\@tempboxa >\hsize
   {\floatlegendstyle #1\floatcounterend}\capstrut #2\par
 \else
   \hbox to\hsize{\leftlegendglue\unhbox\@tempboxa\hfil}%
 \fi
 \ifx\@captype\fig@type\else
   \vskip\tabcapgap
 \fi}

\newcounter{merk}

\def\endfigure{\resetsubfig\end@float}

\@namedef{endfigure*}{\resetsubfig\end@dblfloat}

\def\resetsubfig{\global\let\last@subfig=\undefined}

\def\r@setsubfig{\xdef\last@subfig{\number\value{figure}}%
\setcounter{figure}{\value{merk}}%
\setcounter{merk}{0}}

\def\subfigures{\stepcounter{figure}%
   \@tempcnta=\value{merk}%
   \setcounter{merk}{\value{figure}}%
   \setcounter{figure}{\the\@tempcnta}%
   \def\thefigure{\if@numart\else\thechapter.\fi
   \@arabic\c@merk\alph{figure}}%
   \let\resetsubfig=\r@setsubfig}

\def\samenumber{\addtocounter{\@captype}{-1}%
\@ifundefined{last@subfig}{}{\setcounter{merk}{\last@subfig}}}

%--figuros ir lenteles papil--------------------------------------------------------------------------
\renewcommand\thefigure{\@arabic\c@figure}
\long\def\@makefigurecaption#1#2{%
   \vskip 12\p@\centering{\normalfont\footnotesize{\bfseries #1.} #2\par}}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\,~\thefigure}
\renewenvironment{figure}
               {\let\@makecaption\@makefigurecaption\@float{figure}}
               {\end@float}
\renewenvironment{figure*}
               {\let\@makecaption\@makefigurecaption\@dblfloat{figure}}
               {\end@dblfloat}

\newtoks\beforecaption \beforecaption={\centering}
\long\def\@maketablecaption#1#2{\the\beforecaption\footnotesize%
  \begin{tabular}{l}
  {\normalfont{\bfseries #1.}}  #2\\
  \end{tabular}\par}
\def\thline{%
\noalign{\ifnum0=`}\fi\vskip 3pt\hrule \@height \arrayrulewidth \futurelet
   \reserved@a\t@xhline}
\def\t@xhline{\ifx\reserved@a\hline
                \vskip \doublerulesep
                \vskip-\arrayrulewidth
             \else \vskip 3pt\fi
      \ifnum0=`{\fi}}
\def\boldhline{\noalign{\global\arrayrulewidth.8pt}\hline%
                        \noalign{\global\arrayrulewidth.4pt}}
\def\@tableboxreset{%
        \reset@font
        \centering\footnotesize
        \@setnobreak
        \@setminipage
}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}

\renewenvironment{table}
               {\let\hline\thline\let\@floatboxreset\@tableboxreset%
\let\@makecaption\@maketablecaption\@float{table}}
               {\end@float}
\renewenvironment{table*}
               {\let\hline\thline\let\@floatboxreset\@tableboxreset%
\let\@makecaption\@maketablecaption\@dblfloat{table}}
               {\end@dblfloat}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
               \ #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
%-References ---------------------------------------------------------------------------
% redefinition of the "bibliography" environment
%
\def\biblstarthook#1{\gdef\biblst@rthook{#1}}
%
\AtBeginDocument{%
\ifx\chpbibl\undefined
  \def\bibsection{\section*{\refname}\ifx\sectionmark\@gobble\else
      \markright{\refname}\fi
      \addcontentsline{toc}{section}{\refname}%
      \mtaddtocont{\protect\contentsline{mtchap}{\refname}{\thepage}}%
      \csname biblst@rthook\endcsname}
\else
 \def\bibsection{\chapter*{\refname}\@mkboth{\refname}{\refname}%
     \addcontentsline{toc}{chapter}{\refname}%
     \csname biblst@rthook\endcsname}
\fi}
\ifx\oribibl\undefined % MMA way of life
   \renewenvironment{thebibliography}[1]{\bibsection
         \global\let\biblst@rthook=\undefined
         \def\@biblabel##1{[##1]}
         \small
         \list{\@biblabel{\@arabic\c@enumiv}}%
              {\settowidth\labelwidth{\@biblabel{#1}}%
               \leftmargin\labelwidth
               \advance\leftmargin\labelsep
               \if@openbib
                 \advance\leftmargin\bibindent
                 \itemindent -\bibindent
                 \listparindent \itemindent
                 \parsep \z@
               \fi
               \usecounter{enumiv}%
               \let\p@enumiv\@empty
               \renewcommand\theenumiv{\@arabic\c@enumiv}}%
         \if@openbib
           \renewcommand\newblock{\par}%
         \else
           \renewcommand\newblock{\hskip .11em \@plus.33em \@minus.07em}%
         \fi
         \sloppy\clubpenalty4000\widowpenalty4000%
         \sfcode`\.=\@m}
        {\def\@noitemerr
          {\@latex@warning{Empty `thebibliography' environment}}%
         \endlist}
   \def\@lbibitem[#1]#2{\item[{[#1]}\hfill]\if@filesw
        {\let\protect\noexpand\immediate
        \write\@auxout{\string\bibcite{#2}{#1}}}\fi\ignorespaces}
\else % original bibliography is required
   \let\bibname=\refname
   \renewenvironment{thebibliography}[1]
     {\chapter*{\bibname
        \markboth{\bibname}{\bibname}}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\fi
\ps@myheadings
%----------------------------------------------------------------------------
\usepackage[L7x,T1]{fontenc}
\usepackage[polish]{babel}
\def\KeyW{Keywords}
\def\rez{REZIUMĖ}
\def\raktz{Raktiniai žodžiai}
\def\santr{}

\usepackage[colorlinks,breaklinks,unicode]{hyperref}%backref,
\def\@linkcolor{black}%{red}
\def\@anchorcolor{black}%{black}
\def\@citecolor{black}%{green}
\def\@filecolor{black}%{cyan}
\def\@urlcolor{MyBlue}%{magenta}
\def\@menucolor{black}%{red}
\def\@pagecolor{black}%{red}
\def\@refcolor{black}%{red}

\usepackage{multirow}
\usepackage{graphicx}          % for LaTeX2e
\usepackage{latexsym}
\usepackage{amssymb}
\usepackage{amsmath}
\usepackage[mathscr]{eucal}
\usepackage{amscd}%komutatyvines diagramos
\usepackage{color}
\usepackage{delarray}
\usepackage{makeidx}
\usepackage{enumerate}
\usepackage{pifont}
\usepackage{hyperref}
\usepackage{subcaption}
%\@addtoreset{equation}{section}
\usepackage[a4paper,paperwidth=17cm, paperheight=24cm,margin=2cm,bottom=2cm,top=2cm]{geometry}
%\usepackage[cam,a4,center]{crop} %horigin=-1.0225in,vorigin=-0.995in
%\usepackage[a4paper,paperwidth=6.3in, paperheight=9.45in,margin=0.7875in,bottom=0.7875in,top=0.7875in]{geometry}
%\usepackage[cam,a4,center]{crop} %horigin=-1.0225in,vorigin=-0.995in
\def\theequation{\arabic{equation}}
\def\eqref#1{{\textup{(\ref{#1})}}}
\def\thmref#1{{\textup{\ref{#1}}}}
\def\figref#1{{\textup{Fig.~\ref{#1}}}}
\def\tabref#1{{\textup{Tab.~\ref{#1}}}}
\def\kabb {\mbox{\raisebox{-1.5ex}{"}}}
\def\kabe {``}

% Information about journals
\def\issn{0132-2818}
\def\eissn{2335-898X}
\def\LMD{Liet.\,matem.\,rink. Proc. LMS, Ser.~\!\lmdnumber}
\def\MMA{Math. Model. Anal.}
\def\@jid{LMD}
\def\@shortjid{lmd}
\def\doiMMA{10.3846/1392-6292}
\definecolor{MyBlue}{rgb}{0.0, 0.2, 0.6}%darkpowderblue

\def\oddpages{
% \href{https://doi.org/10.15388/LMR.20\lmdyear.\nr}{\textcolor{MyBlue}{\scriptsize{\LMD}, \textbf{{\lmdvolume}}:\firstpage--\lastpage, 20\lmdyear}}
}
\def\evenpages{
% {\hfil\scriptsize{\href{http://www.journals.vu.lt/LMR}{\textcolor{MyBlue}{http://www.journals.vu.lt/LMR}}}}
}


\def\LMDp{{\sc {Akademia Górniczo-Hutnicza\\im. Stanisława Staszica w Krakowie}}}
\def\LMDpp{Vol.\,\lmdvolume, 20\lmdyear, pages \firstpage--\lastpage }
\def\LMDpr{Wydział Informatyki}
\def\LMDpv{\LMDrr}
\def\LMDdoi{\doi{10.15388/LMR.20\lmdyear.\nr}}
\def\LMDr{ISSN \issn}
\def\LMDrr{eISSN \eissn}
\def\LMDrrr{www.mii.lt/LMR/}
\def\LMDppp{\copyright\,Institute of Mathematics and Informatics, 20\lmdyear}
\def\lmdvolume{X}
\def\lmdnumber{x}
\def\lmdyear{xx}
\def\online{Mxx 1, 20xx}
\def\code{Author's Version}
\def\LMDJarticle{\def\code{Editor's Version}}
\def\Redv#1#2#3{\textbf{#1}\quad\textbf{#2}\qquad\quad\  {\tt\footnotesize{#3}}\\ }
\def\Redvv#1#2{{\footnotesize{#1}}, {\footnotesize{#2}}\\ }
\def\Red#1#2#3#4{\scriptsize\textbf{#1}\ (#2)&{\scriptsize {#3}\quad {\tt{#4}}}\\ }
\def\Redd#1#2{&{\scriptsize {#1}\quad {\tt{#2}}}\\ }
\def\Ree#1{ &{\scriptsize {\tt{#1}}}\\ }
\def\emptypage{\newpage $\,$}
\def\t{\hskip -1em.\ }
\def\Keywords{\keywords{\lmdkeywords}}%\vspace{-5.0mm}\ams{\lmdams.}
\def\AMSwords{\ams{\lmdams}}
\def\LMDJarticle{\setcounter{footnote}{\firstfootnote}\renewcommand{\thefootnote}{\arabic{footnote}}\input{lmd_pdf.def}\c@page=\firstpage}%
\def\LMDJCLS{\renewcommand{\thefootnote}{\fnsymbol{footnote}}\runtitle{\lmdruntitle} \runauthor{\lmdrunauthor} \def\KKeywords{\keywords{\lmdkeywords}}\def\AMSwords{\ams{\lmdams}}}%\vspace{-5.0mm}\ams{\lmdams.}
\def\doi#1{\href{https://doi.org/#1}{\textcolor{MyBlue}{https://doi.org/#1}}}
\newcommand{\ID}[1]{\href{https://orcid.org/#1}{\includegraphics[width=3mm]{orcid.eps}}}
\newcommand{\ROR}[2]{\href{https://ror.org/#2}{#1}}
\newcommand{\RORID}[1]{\href{https://ror.org/#1}{\ \includegraphics[width=3mm]{ror.png}}}
\newcommand{\COR}[1]{\href{mailto:#1}{{}^{\includegraphics[width=2mm]{cor.png}}\,}}
\newcommand{\CORR}[1]{\href{mailto:#1}{{}^{\includegraphics[width=1.75mm]{cor.png}}\,}}
\def\arxiv#1{\href{https://arxiv.org/abs/#1}{{\color{MyBlue}https://arxiv.org/abs/#1}}}
\def\Doi#1{\href{https://doi.org/#1}{#1}}
\def\Summary{\subsection*{\footnotesize\textmd{\rez}}\small{\textbf{\lmdtitleLT}}\vspace{2mm}\footnotesize\newline{\emph{\lmdrunauthor}}\vspace{1mm}\newline{\lmdabstractLT}\vspace{1mm}\newline{{\emph{\raktz\emph{:}\ }}\lmdkeywordsLT}}
\def\CR{\footnote{\CRR}\!\!\!{\color{white}${}^\blacksquare$}}
\def\CRR{\!\!\!\!\!\!{\color{white}${}^\blacksquare$}\newline\footnotesize{${}^{{}_{\text{{\textcopyright}}}}$}20\lmdyear\ Authors. Published by \href{https://www.vu.lt/leidyba/en/}{\textcolor{MyBlue}{Vilnius University Press}}\\
This is an Open Access article distributed under the terms of the \href{https://creativecommons.org/licenses/by/4.0/}{\textcolor{MyBlue}{Creative Commons Attribution Licence}}, which permits unrestricted use,
distribution, and reproduction in any medium, provided the original author and source are credited.}
\def\Email#1{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi 
\vspace{-1mm}\mbox{\ \footnotesize{$\CORR{\lmdcorresp}$}\footnotesize{\textsf{Corresponding author:\ }\vbox{\href{mailto:#1}{\tt{#1}}}}}}
\def\email#1{\if@email\vskip1pt\else\vskip1pt\@emailtrue\fi 
\vspace{-1mm}\mbox{\quad\footnotesize{\textsf{E-mail:\ }\vbox{\href{mailto:#1}{\tt{#1}}}}}}
\endinput
%%
%% End of file `book.cls'.
