package com.vgb.service;

import com.vgb.dao.ChequeBookDAOImpl;
import com.vgb.model.ChequeBook;
import com.vgb.model.ChequeLeaf;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.List;

public class ChequeBookService {
    private static final Logger logger = LoggerFactory.getLogger(ChequeBookService.class);
    private ChequeBookDAOImpl chequeBookDAO = new ChequeBookDAOImpl();

    public List<ChequeBook> getActiveChequeBooks(long accountId) throws Exception {
        try {
            return chequeBookDAO.getActiveChequeBooksByAccount(accountId);
        } catch (SQLException e) {
            logger.error("Error retrieving active cheque books", e);
            throw new Exception("Failed to load active cheque books: " + e.getMessage());
        }
    }

    public List<ChequeLeaf> getUnusedCheques(long chequeBookId) throws Exception {
        try {
            return chequeBookDAO.getUnusedLeavesByChequeBook(chequeBookId);
        } catch (SQLException e) {
            logger.error("Error retrieving unused cheques", e);
            throw new Exception("Failed to load unused cheques: " + e.getMessage());
        }
    }

    public void validateCheque(long accountId, String chequeBookNumber, String chequeNumber) throws Exception {
        try {
            ChequeLeaf leaf = chequeBookDAO.getChequeLeaf(chequeBookNumber, chequeNumber);
            if (leaf == null) {
                throw new Exception("Cheque leaf #" + chequeNumber + " not found or does not belong to Cheque Book " + chequeBookNumber + ".");
            }

            if (!"unused".equalsIgnoreCase(leaf.getStatus())) {
                throw new Exception("Cheque leaf #" + chequeNumber + " is already " + leaf.getStatus() + ".");
            }

            // Load chequebook to verify account
            List<ChequeBook> activeBooks = chequeBookDAO.getActiveChequeBooksByAccount(accountId);
            boolean belongsToAccount = false;
            for (ChequeBook cb : activeBooks) {
                if (cb.getChequebookId() == leaf.getChequebookId() && cb.getChequebookNumber().equals(chequeBookNumber)) {
                    belongsToAccount = true;
                    if (!"active".equalsIgnoreCase(cb.getStatus())) {
                        throw new Exception("Cheque Book " + chequeBookNumber + " is not active (Status: " + cb.getStatus() + ").");
                    }
                    break;
                }
            }

            if (!belongsToAccount) {
                throw new Exception("Cheque Book " + chequeBookNumber + " does not belong to the selected account.");
            }

        } catch (SQLException e) {
            logger.error("Error validating cheque leaf", e);
            throw new Exception("Cheque leaf validation failed: " + e.getMessage());
        }
    }
}
