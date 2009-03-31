\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{tufte-handout}[2004/02/04 v0.1 Tufte-handout class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}%
                \typeout{NOTE: Passing ``\CurrentOption'' option on to the
                         standard LaTeX book class}}
\ProcessOptions
\LoadClass[11pt]{article}%
 \RequirePackage[includemp, letterpaper,%
                 marginparsep=0.375in,
                 marginparwidth=2in]{geometry}
 \RequirePackage{paralist}
 \RequirePackage[strict]{chngpage}% for changing page width

% tie \intextsep to \baselineskip to more tightly integrate layout
\setlength{\intextsep}{0.5\baselineskip \@plus 2\p@ \@minus 1\p@}

% change floating defaults to include 'here' to promote text/float integration
\def\fps@figure{htbp}
\def\fps@table{htbp}

% set vertical space between margin pars
\setlength\marginparpush{1.6\parsep}

% shrink above and below display skips:
\setlength\abovedisplayskip{3pt plus 1pt minus 1pt}
\setlength\belowdisplayskip{3pt plus 1pt minus 1pt}

% shrink above and below caption skips:
\setlength\abovecaptionskip{3pt}
\setlength\belowcaptionskip{3pt}


% create a variable to hold margin overhang length
\newlength{\tufteh@overhang}
\setlength{\tufteh@overhang}{\marginparwidth}
\addtolength{\tufteh@overhang}{\marginparsep}

\renewcommand\maketitle{\par
  \global\let\and\relax
  \begingroup
    \renewcommand\thefootnote{\@fnsymbol\c@footnote}%
    \def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
    \long\def\@makefntext##1{\parindent 1em\noindent
            \hb@xt@1.8em{%
                \hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
    \newpage
    \global\@topnum\z@   % Prevents figures from going at top of page.
    \@maketitle
    \@thanks
  \endgroup
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
}
\def\@maketitle{%
  \newpage
  \let\footnote\sidenote
  {\noindent\LARGE\bfseries\slshape \@title\par}%
  \vskip 6pt%
  {\noindent\large\slshape \@author\par}
  \vskip 3pt%
  {\noindent\normalsize\slshape \@date\par}%
}

% modify paralist compact enumeration list to add rightmargin
\def\@compactenum@{%
  \expandafter\list\csname label\@enumctr\endcsname{%
    \usecounter{\@enumctr}%
    \rightmargin=2em% added this
    \parsep\plparsep
    \itemsep\plitemsep
    \topsep\pltopsep
    \partopsep\plpartopsep
    \def\makelabel##1{\hss\llap{##1}}}}

% modify \raggedright from latex.ltx to allow hyphenation per Donald Arseneau
\def\tufteh@raggedright{%
  \let\\\@centercr\@rightskip\z@ plus 0.08\hsize% changed this line
  \rightskip\@rightskip
  \leftskip\z@skip
  \parindent\z@}

% tone down sectioning

\setcounter{secnumdepth}{1}
\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-2.2ex \@plus -0.5ex \@minus -0.1ex}%
                                   {1.1ex \@plus.1ex}%
                                   {\normalfont\normalsize\Large\bfseries\slshape}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-1.625ex\@plus -0.5ex \@minus -0.1ex}%
                                     {0.75ex \@plus 0.1ex}%
                                     {\normalfont\normalsize\large\slshape}}

% Add caption font and style hooks
\newcommand{\captionfont}{\scriptsize\sffamily}
\newcommand{\captionfill}{\tufteh@raggedright}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\captionfont\captionfill #1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    {\captionfont\captionfill #1: #2\par}
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}


% redefine the float* commands to spans column width
% plus marginparwidth [article.cls] using chngpage.sty
\renewenvironment{figure*}[1][htbp]
               {\@float{figure}[#1]
                 \begin{adjustwidth}{}{-\tufteh@overhang}%
                  \begin{minipage}{\linewidth}}
               {  \end{minipage}%
                 \end{adjustwidth}%
                \end@float}
\renewenvironment{table*}[1][htbp]
               {\@float{table}[#1]
                 \begin{adjustwidth}{}{-\tufteh@overhang}%
                  \begin{minipage}{\linewidth}}
               {  \end{minipage}%
                 \end{adjustwidth}%
                \end@float}

\providecommand\newthought[1]{\vspace{2\parsep}%
                           {\noindent\scshape #1}}

% span the full text width
\newenvironment{fullwidth}% uses [chngpage.sty]
 {\begin{adjustwidth}{}{-\tufteh@overhang}}%
 {\end{adjustwidth}}

% font hook to control marginal items
\newcommand{\marginfont}{\normalfont\scriptsize}

% sidenotes
\newcommand{\sidenote}[2][0pt]%
  {\footnotemark%
   \marginpar{\marginfont
              \vspace*{#1}
              \textsuperscript{\thefootnote}%
              \hspace{1pt}%
              \tufteh@raggedright #2}%
  }

% usurp \footnotes while we're at it
\let\footnote\sidenote

% marginfigure
\newcommand{\marginfigure}[2][0pt]%
 {\marginpar{\def\@captype{figure}
             \marginfont
             \vspace*{#1}
             \tufteh@raggedright #2}%
 }

% margintable
\newcommand{\margintable}[2][0pt]%
 {\marginpar{\def\@captype{table}
             \marginfont
             \vspace*{#1}
             \tufteh@raggedright #2}%
 }

\AtBeginDocument{
  \tufteh@raggedright%
  \setlength\parindent{1em}%
  \@ifundefined{wrapoverhang}{}% else wrapfig package loaded
    {\setlength{\wrapoverhang}{\tufteh@overhang}}
  \@ifundefined{captionnamefont}{}% else ccaption package loaded
    {\captionnamefont{\captionfont}
     \captiontitlefont{\captionfont}
     \captionstyle{\tufteh@raggedright}
    }
}

\endinput
