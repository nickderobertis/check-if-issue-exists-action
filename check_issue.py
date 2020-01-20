import os
from dataclasses import dataclass
from typing import Sequence, Optional, List
from github import Github
from github.Issue import Issue
from github.PaginatedList import PaginatedList

TITLE_INPUT = 'INPUT_TITLE'
LABELS_INPUT = 'INPUT_LABELS'
REPO_INPUT = 'INPUT_REPO'
GH_TOKEN_INPUT = 'INPUT_TOKEN'


@dataclass
class RepoLookupParams:
    title: Optional[str]
    labels: Optional[Sequence[str]]

    def __post_init__(self):
        if self.title is None and self.labels is None:
            raise ValueError(
                'Must provide title or labels. Specify them in the workflow as with: title or with: labels or both')

    @classmethod
    def from_env(cls):
        title = os.environ.get(TITLE_INPUT, None)
        labels_str = os.environ.get(LABELS_INPUT, None)
        labels: Optional[List[str]] = None
        if labels_str is not None:
            labels = [lab.strip() for lab in labels_str.split(',')]

        return cls(
            title=title,
            labels=labels
        )

    def matches_issue(self, issue: Issue) -> bool:
        if self.title is not None and issue.title != self.title:
            return False

        if self.labels is not None:
            for lookup_label_name in self.labels:
                matched = False
                for existing_label in issue.labels:
                    if lookup_label_name == existing_label.name:
                        matched = True
                        break
                if not matched:
                    return False

        return True

    def matches_issue_in_repo(self, repo_path: str, gh_obj: Github) -> bool:
        issues = get_issues_for_repo(repo_path, gh_obj)
        for issue in issues:
            if self.matches_issue(issue):
                print(f'Found issue matching query parameters: {issue}')
                return True

        print('Did not find issues matching query parameters.')
        return False


def get_issues_for_repo(repo_path: str, gh_obj: Github) -> PaginatedList:
    repo = gh_obj.get_repo(repo_path)
    return repo.get_issues()


def get_repo_from_env() -> str:
    repo_path = os.environ.get(REPO_INPUT, None)
    if repo_path is None:
        raise ValueError(
            'Must provide repo. Specify it in with workflow as with: repo, '
            'e.g. with: repo: whoopnip/check-if-issue-exists-action'
        )
    return repo_path


def get_gh_obj() -> Github:
    gh_token = os.environ.get(GH_TOKEN_INPUT, None)
    if gh_token is None:
        raise ValueError(
            'Must provide Github Token. Specify it in with workflow as with: token, '
            'e.g. with: token: DFSDF320394SADLKJDASSAD'
        )
    return Github(gh_token)


def set_output(variable: str, value: str) -> None:
    print(f'::set-output name={variable}::{value}')


def set_exists_output(value: str) -> None:
    set_output('exists', value)


def main():
    repo_path = get_repo_from_env()
    gh_obj = get_gh_obj()
    params = RepoLookupParams.from_env()
    print(f'Searching issues with query parameters: {params}')
    if params.matches_issue_in_repo(repo_path, gh_obj):
        set_exists_output('true')
    else:
        set_exists_output('false')


if __name__ == '__main__':
    main()
