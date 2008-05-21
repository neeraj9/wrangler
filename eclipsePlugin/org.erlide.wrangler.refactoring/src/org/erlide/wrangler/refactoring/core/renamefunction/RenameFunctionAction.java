package org.erlide.wrangler.refactoring.core.renamefunction;

import org.erlide.wrangler.refactoring.core.WranglerRefactoring;
import org.erlide.wrangler.refactoring.ui.WranglerRefactoringAction;
import org.erlide.wrangler.refactoring.ui.WranglerRefactoringWizard;

public class RenameFunctionAction extends WranglerRefactoringAction {

	@Override
	protected String initRefactoringName() {
		return "Rename function";
	}

	@Override
	protected WranglerRefactoring initWranglerRefactoring() {
		return new RenameFunctionRefactoring(parameters);
	}

	@Override
	protected WranglerRefactoringWizard initWranglerRefactoringWizard() {
		return new RenameFunctionWizard(refactoring,
				WranglerRefactoringWizard.DIALOG_BASED_USER_INTERFACE);
	}

}