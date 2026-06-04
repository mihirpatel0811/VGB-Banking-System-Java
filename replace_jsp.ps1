# PowerShell script to safely edit UTF-16 LE jsp file
$filePath = "d:\InternShip Project\VGB-Banking-System\src\main\webapp\admin\account.jsp"
$encoding = [System.Text.Encoding]::Unicode # UTF-16 LE
$content = [System.IO.File]::ReadAllText($filePath, $encoding)

$search = @"
<button type="button" class="action-tab-btn" onclick="openEditAccountModal(this)" data-id="`${acc.accountId}" data-custid="`${acc.customerId}" style="padding: 6px 10px; font-size: 0.95rem; background: rgba(245, 158, 11, 0.1); color: #d97706; border: none; border-radius: var(--radius-sm); cursor: pointer; margin-right: 5px;" title="Edit Account"><i class="bx bx-edit"></i></button>
                                                            <c:if test="`${acc.status != 'closed'}">
                                                                <button type="button" class="action-tab-btn" onclick="confirmCloseAccount('`${acc.accountId}', '`${acc.accountNumber}')" style="padding: 6px 10px; font-size: 0.95rem; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: none; border-radius: var(--radius-sm); cursor: pointer;" title="Close Account"><i class="bx bx-x-circle"></i></button>
                                                            </c:if>
"@

$replace = @"
<button type="button" class="action-tab-btn" onclick="openEditAccountModal(this)" data-id="`${acc.accountId}" data-custid="`${acc.customerId}" style="padding: 6px 10px; font-size: 0.95rem; background: rgba(245, 158, 11, 0.1); color: #d97706; border: none; border-radius: var(--radius-sm); cursor: pointer; margin-right: 5px;" title="Edit Account"><i class="bx bx-edit"></i></button>
                                                            <c:if test="`${acc.status != 'closed'}">
                                                                <button type="button" class="action-tab-btn" onclick="confirmCloseAccount('`${acc.accountId}', '`${acc.accountNumber}')" style="padding: 6px 10px; font-size: 0.95rem; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: none; border-radius: var(--radius-sm); cursor: pointer;" title="Close Account"><i class="bx bx-x-circle"></i></button>
                                                            </c:if>
                                                            <button type="button" class="action-tab-btn" onclick="confirmDeleteAccount('`${acc.accountId}', '`${acc.accountNumber}')" style="padding: 6px 10px; font-size: 0.95rem; background: rgba(239, 68, 68, 0.1); color: #ef4444; border: none; border-radius: var(--radius-sm); cursor: pointer; margin-left: 5px;" title="Delete Account & Customer"><i class="bx bx-trash"></i></button>
"@

# Replace globally
if ($content.Contains($search)) {
    $newContent = $content.Replace($search, $replace)
    [System.IO.File]::WriteAllText($filePath, $newContent, $encoding)
    Write-Output "Successfully updated 3 table action columns."
} else {
    Write-Error "Could not find the target search block in JSP!"
}
