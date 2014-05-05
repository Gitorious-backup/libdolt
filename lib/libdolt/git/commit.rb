# encoding: utf-8
#--
#   Copyright (C) 2012 Gitorious AS
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++
require "time"

module Dolt
  module Git
    class Commit
      def self.parse_log(log)
        commits = []
        lines = log.split("\n")
        commits << extract_commit(lines) while lines.length > 0
        commits
      end

      def self.extract_commit(lines)
        commit = { :oid => lines.shift.split(" ")[1] }
        while (line = lines.shift) != ""
          pieces = line.split(": ")
          extract_property(commit, pieces[0], pieces[1])
        end

        commit[:summary] = extract_commit_summary(lines)
        commit[:message] = extract_commit_message(lines)
        commit
      end

      def self.extract_property(hash, name, value)
        key = name.downcase.to_sym

        case key
        when :author
          pieces = value.match(/(.*)\s<(.*)>/)
          name = HTMLEscape.entityfy(pieces[1])
          email = HTMLEscape.entityfy(pieces[2])
          value = { :name => name, :email => email }
        when :date
          value = Time.parse(value)
        end

        hash[key] = value
      end

      def self.extract_commit_summary(lines)
        return "" if commit_start?(lines.first)
        summary = lines.shift
        lines.shift if lines.first == ""
        summary = summary.sub(/^    /, "")
        HTMLEscape.entityfy(summary)
      end

      def self.extract_commit_message(lines)
        message = ""

        while !lines.first.nil? && !commit_start?(lines.first)
          message << lines.shift
        end

        HTMLEscape.entityfy(message)
      end

      def self.commit_start?(line)
        line =~ /^commit [a-z0-9]{40}$/
      end
    end
  end
end
