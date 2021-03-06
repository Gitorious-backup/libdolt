# encoding: utf-8
#--
#   Copyright (C) 2013 Gitorious AS
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

module Dolt
  module Git
    class Process
      attr_reader :stdin, :stdout, :stderr

      def initialize(stdin, stdout, stderr, wait_thread)
        @stdin = stdin
        @stdout = stdout
        @stderr = stderr
        @wait_thread = wait_thread
      end

      def success?
        process_status.success?
      end

      def exit_code
        process_status.exitstatus
      end

      def exception
        Exception.new(stderr.read)
      end

      private

      def process_status
        @wait_thread.value
      end
    end
  end
end
