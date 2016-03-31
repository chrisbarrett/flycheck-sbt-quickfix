;;; flycheck-sbt-quickfix-test.el --- Tests for flycheck-sbt-quickfix.el

;; Copyright (C) 2013 Chris Barrett

;; Author: Chris Barrett <chris.d.barrett@me.com>

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Tests for flycheck-sbt-quickfix.el

;;; Code:

(require 'ert)
(require 'flycheck-sbt-quickfix)

(defconst sample-quickfix-file "
[error] /project-directory/src/main/scala/Foo.scala:12: not found: value fixme1
[error]   fixme1
[error]   ^
[warn] /project-directory/src/main/scala/Foo.scala:43: not found: value fixme2
[warn]   fixme2
[warn]   ^
[error] two errors found
[error] (compile:compileIncremental) Compilation failed
")

(ert-deftest parses-filenames-for-errs ()
  (let ((result (-map #'flycheck-error-filename (flycheck-sbt-quickfix--parse-quickfix-file sample-quickfix-file))))
    (should (equal result '("/project-directory/src/main/scala/Foo.scala"
                            "/project-directory/src/main/scala/Foo.scala")))))

(ert-deftest parses-line-numbers-for-errs ()
  (let ((result (-map #'flycheck-error-line (flycheck-sbt-quickfix--parse-quickfix-file sample-quickfix-file))))
    (should (equal result '(12 43)))))

(ert-deftest parses-levels-for-errs ()
  (let ((result (-map #'flycheck-error-level (flycheck-sbt-quickfix--parse-quickfix-file sample-quickfix-file))))
    (should (equal result '(error warning)))))

(ert-deftest parses-messages-for-errs ()
  (let ((result (-map #'flycheck-error-message (flycheck-sbt-quickfix--parse-quickfix-file sample-quickfix-file))))
    (should (equal result '("not found: value fixme1"
                            "not found: value fixme2")))))

(provide 'flycheck-sbt-quickfix-test)

;;; flycheck-sbt-quickfix-test.el ends here
